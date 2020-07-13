import personas.*
import manzanas.*

object simulacion {
	var property diaActual = 0
	const property manzanas = []
	
	// parametros del juego
	const property chanceDePresentarSintomas = 30
	const property chanceDeContagioSinCuarentena = 25
	const property chanceDeContagioConCuarentena = 2
	const property personasPorManzana = 10
	const property duracionInfeccion = 20

	/*
	 * este sirve para generar un azar
	 * p.ej. si quiero que algo pase con 30% de probabilidad pongo
	 * if (simulacion.tomarChance(30)) { ... } 
	 */
	method tomarChance(porcentaje) { return (0.randomUpTo(100) < porcentaje) }
	
	// agrega una manzana a la simulzacion
	method agregarManzana(manzana) { manzanas.add(manzana) }
	
	// retorna un booleano
	method debeInfectarsePersona(persona,cantidadContagiadores) {  
		var comoContagia
		const chanceDeContagio = 
		if (persona.respetaCuarentena()) {
			self.chanceDeContagioConCuarentena() } 
		else { 
				self.chanceDeContagioSinCuarentena()
			}
		if (cantidadContagiadores == 4) { comoContagia = cantidadContagiadores } else { comoContagia = 1 }
		return  (1..comoContagia).any({n => self.tomarChance(chanceDeContagio)})
	}
	
	// define al azar si la persona tendra sintomas o no.
	method debeTenerSintomas(persona) { 
		persona.presentaSintomas(self.tomarChance(self.chanceDePresentarSintomas()))
	}
	
	// simmula la decision de las personas a quedarse aisladas o no
	method decidirAislarseONo() {
		manzanas.forEach( { manzana => manzana.simulacionDecisionDeAislarse() } )
	}
	
	// translado o movimiento de un habitante entre manzanas
	method transladarHabitante(manzana) { 
		manzana.transladoDeUnHabitante()
	} 
		
	// simula la propagacion del contagio
	method propagacionContagio() { 
		manzanas.forEach( { manzana => manzana.simulacionContagiosDiarios() } )
	}
	
	// simula el translado de personas entre manzanas
	method transladoDePersonas() {
		manzanas.forEach( { manzana => self.transladarHabitante(manzana) } )
	}
	
	// simula la curacion de personas, pasada los 20 dias
	method ejecutarCuracion() {
		manzanas.forEach( { manzana => manzana.simulacionCuracion() } )
	}
	
	// simular aislara los infectados con sintomas
	method aislarInfectadosConSintomasEnElBarrio() {
		manzanas.forEach( { manzana => manzana.aislarInfectadosConSintomas() } )
	}
	
	// simular que convence a las persona de una cuadra a que hagan cuarentena
	method convenserARespectarCuarentena(manzana) {
		manzana.mandarPersonasACuarentena()
	}
	
	// retorna una manzanda al azar
	method elegirUnaManzanaAlAzar() { 
		return manzanas.get(0.randomUpTo(manzanas.size() - 1)) 
	}
	
	// simular caso importando de persona infectada
	method importarCaso() {
		const personaInfectada = new Persona()
		personaInfectada.infectarse()
		personaInfectada.presentaSintomas(false)
		self.elegirUnaManzanaAlAzar().mudarAEstaManzana(personaInfectada)
	}
	
	// simula el avance de un dia en pandemia
	method avanzarUnDia() { 
		manzanas.forEach( { manzana => manzana.pasarUnDia() } )
		self.diaActual(self.diaActual() + 1)
	}
	method avanzarCincoDias() {
		5.times({ veces => self.avanzarUnDia() })
	}

	method crearManzana() {
		const nuevaManzana = new Manzana()
		// agregar la cantidad de personas segun self.personasPorManzana()
		const persona = new Persona()
		// self.personasPorManzana().times({ veces => nuevaManzana.mudarAEstaManzana(persona)})
		self.SimularMudarMultiplesPersonasAManzana(nuevaManzana,self.personasPorManzana(),persona)
		return nuevaManzana
	}
	
	method SimularMudarMultiplesPersonasAManzana(manzana,cantidad,persona) {
		(0..cantidad - 1).forEach({ x => manzana.mudarAEstaManzana(persona) })
	}
	
	// Consultas:
	// sumar cantidad de personas del barrio.
	
	method cuantasPersonasVivenEnelBarrio() {
		return manzanas.sum( { manzana => manzana.cuantaGenteVive() } )
	}
	
	// sumar cantidad de personas aisladas en la simunacion del barrio
	method cuantasPersonasEstanAisladasEnElBarrio() {
		return manzanas.sum( { manzana => manzana.cuantasPersonasEstanAisladas() } )	
	}
	
	// sumar la cantidad de personas infectadas en la simulacion del barrio
	method cuantasPersonasEstanInfectadasEnElBarrio() {
		return manzanas.sum( { manzana => manzana.cuantasPersonasEstanInfectadas() } )	
	}
	
	// sumar al cantidad de personas con sintomas en la simulacion del barrio
	method cuantasPersonasTienenSintomasEnElBarrio() {
		return manzanas.sum( { manzana => manzana.cuantasPersonasTienenSintomas() } )
	}
	
	// sumar al cantidad de personas con sintomas en la simulacion del barrio
	method cuantasPersonasRespetanCuarentenaEnElBarrio() {
		return manzanas.sum( { manzana => manzana.cuantasPersonasRespetanCuarentena() } )
	}
}
