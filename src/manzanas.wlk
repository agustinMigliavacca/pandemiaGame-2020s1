import personas.*
import simulacion.*
import wollok.game.*

class Manzana {
	const property personas = []
	var property position
	
	/*method image() { // implementar objeto de colores?
		// reeemplazarlo por los distintos colores de acuerdo a la cantidad de infectados
		// también vale reemplazar estos dibujos horribles por otros más lindos
		return "blanco.png"
	}
	*/
	method siEstanTodosInfectados() {
		return personas.all( { persona => persona.estaInfectada() } )
	}
	
	method image() {
		var imagenSalida
		if (self.siEstanTodosInfectados() and self.cuantaGenteVive() != 0) 
			{ imagenSalida = color.imagen(rojo) }
      		else if (self.cuantasPersonasEstanInfectadas() > 7 and self.cantidadContagiadores() < self.cuantaGenteVive()) 
      		{ imagenSalida = color.imagen(naranjaOscuro) } 
      		else if (self.cuantasPersonasEstanInfectadas().between(4,7)) 
      		{ imagenSalida = color.imagen(naranja) } 
      		else if (self.cuantasPersonasEstanInfectadas().between(1,3)) 
      		{ imagenSalida = color.imagen(amarillo) } 
      		else { imagenSalida = color.imagen(transparente) } 
    	return imagenSalida
    }
    
	
	// este les va a servir para el movimiento
	method esManzanaVecina(manzana) {
		return manzana.position().distance(position) == 1
	}

	method pasarUnDia() {
		self.transladoDeUnHabitante()
		self.simulacionContagiosDiarios()
		self.simulacionCuracion()
	}
	
	method mudarAEstaManzana(persona) {
		personas.add(persona)
	}
	
	method mudarDeEstaManzana(persona) {
		personas.remove(persona)
	}
	
	method personaSeMudaA(persona, manzanaDestino) { // funcion complemento del traslado
		self.mudarDeEstaManzana(persona)
		manzanaDestino.mudarAEstaManzana(persona)
	}
	
	method cantidadContagiadores() {
	
		return self.cuantasPersonasEstanInfectadasYNoAisladas()
	}
	
	method noInfectades() {
		return personas.filter({ persona => not persona.estaInfectada() })
	} 	
	
	method simulacionContagiosDiarios() { 
		const cantidadContagiadores = self.cantidadContagiadores()
		if (cantidadContagiadores > 0) {
			self.noInfectades().forEach({ persona => 
				if (simulacion.debeInfectarsePersona(persona,cantidadContagiadores)) {
					persona.infectarse()
				}
			})
		}
	}
	
	// simula la decision de las personas a quedarse aisladas o no
	method simulacionDecisionDeAislarse() { 
		personas.forEach( { persona => if (not persona.presentaSintomas()) {
			persona.estaAislada(simulacion.tomarChance(30))
			} // simulacion.estaraAisladaONo(persona)
		})
	}
	
	// simula la curacion de las personas que superan los dias de infeccion en la manzana
	method simulacionCuracion() {
		personas.forEach( { persona => persona.curacion() } )
	}
	
	// aislar a infectados con sintomas
	method aislarInfectadosConSintomas() {
		personas.forEach( { persona => 
			if (persona.estaInfectada() and persona.presentaSintomas()) {
				persona.estaAislada(true)
			}
		} )
	}
	
	// mandar a la personas a que cumplar cuarentena
	method mandarPersonasACuarentena() {
		personas.forEach( { persona => persona.respetaCuarentena(true) } )
	}
	
	method transladoDeUnHabitante() {
		const quienesSePuedenMudar = personas.filter({ pers => not pers.estaAislada()  })
		if (quienesSePuedenMudar.size() > 2) {
			const viajero = quienesSePuedenMudar.anyOne()
			const destino = simulacion.manzanas().filter({ manz => self.esManzanaVecina(manz) }).anyOne()
			self.personaSeMudaA(viajero, destino)			
		}
	}
	
	//  funciones agregadas 
	
	method cuantaGenteVive() {
		return personas.size()
	}
	
	// contar la cantidad de personas de estan infectadas en la manzana
	method cuantasPersonasEstanInfectadas() {
		return personas.count( { persona => persona.estaInfectada() } )
	}
	
	method cuantasPersonasEstanInfectadasYNoAisladas() { 
		return personas.count( { persona => persona.estaInfectada() and not persona.estaAislada() } )
	}
	
	// contar la cantidad de personas de estan aisladas en la manzana
	method cuantasPersonasEstanAisladas() {
		return personas.count( { persona => persona.estaAislada() } )
	}
	
	// contar la cantidad de personas de estan en cuarentena en la manzana
	method cuantasPersonasRespetanCuarentena() {
		return personas.count( { persona => persona.respetaCuarentena() } )
	}
	
	// contar la cantidad de personas que tienen sintomas en la manzana
	method cuantasPersonasTienenSintomas() {
		return personas.count( { persona => persona.presentaSintomas() } )
	}
	
}


object blanco { method image() = return "blanco.png"}
object naranjaOscuro { method image() = return "advertenciaNaranjaOscuro.png"}
object amarillo { method image() = return "advertenciaAmarillo.png"}
object rojo {method image() = return "advertenciaRoja.png"}
object naranja { method image() = return "advertenciaNaranja.png"}
object transparente { method image() = return "transparente.png"}

object color { 
	method imagen(color) { return color.image() }	
}