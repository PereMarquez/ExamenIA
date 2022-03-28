(deffacts datos
    (stock cajas naranja 5 manzana 5 caqui 5 uva 5)
    (robot linea-pedido palet naranja palet manzana palet caqui palet uva)
    (pedido naranja 2 manzana 1 caqui 3 uva 0)
    (maximo cajas 3)
)

(defrule inicializar-stock
    (declare (salience 100))
    ?f <- (stock cajas naranja ?cajasNaranja manzana ?cajasManzana caqui ?cajasCaqui uva ?cajasUva)
    ?f2 <- (robot linea-pedido palet naranja palet manzana palet caqui palet uva)
    =>
    (retract ?f2)
    (assert (robot linea-pedido palet naranja ?cajasNaranja palet manzana ?cajasManzana palet caqui ?cajasCaqui palet uva ?cajasUva))
)

(defrule finalizar-pedido
    (declare (salience 50))
    ?f <- (robot linea-pedido palet naranja ?cajasNaranja palet manzana ?cajasManzana palet caqui ?cajasCaqui palet uva ?cajasUva)
    ?f2 <- (pedido naranja ?cajasNaranja manzana ?cajasManzana caqui ?cajasCaqui uva ?cajasUva)
    =>
    
    (assert (robot linea-pedido palet naranja ?cajasNaranja palet manzana ?cajasManzana palet caqui ?cajasCaqui palet uva ?cajasUva))
)

