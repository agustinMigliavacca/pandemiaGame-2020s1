import simulacion.*


class Persona {
    var property estaAislada = false
    var property presentaSintomas  = false
    var property diaQueSeInfecto = 0 
    var property respetaCuarentena = false
    var estaInfectada = false

    method estaInfectada() { return estaInfectada }
    
    method infectarse() {
        	estaInfectada = true
        	simulacion.debeTenerSintomas(self) // sortea la posibilidad de tener sintoma
        	self.diaQueSeInfecto(simulacion.diaActual())      
    }
    method curacion() { 
    	if (simulacion.diaActual() - self.diaQueSeInfecto() == simulacion.duracionInfeccion()
    	) {
    		estaInfectada = false
    		self.presentaSintomas(false)
    		self.diaQueSeInfecto(0)
    		self.estaAislada(false)
    	}
    }

}