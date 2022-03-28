(deffacts datos
    (stock cajas naranja 5 manzana 5 caqui 5 uva 5)
    (robot linea-pedido palet naranja 0 palet manzana 0 palet caqui 0 palet uva 0)
    (pedido naranja 3 manzana 1 caqui 2 uva 4)
    (maximo-cajas 3)
)

(defrule preparar-naranja-de-una
    (declare (salience 10))
    ?f <- (robot linea-pedido $?x palet naranja ?cajasNaranja $?y)
    ?f2 <- (pedido naranja ?pedidoNaranja $?z)
    ?f3 <- (maximo-cajas ?maxCajas)
    (test (<= ?cajasFruta ?maxCajas))
    =>
    assert((robot linea-pedido $?x pedido naranja ?pedidoNaranja palet naranja (- ?cajasNaranja ?pedidoNaranja) $?z))
)

(defrule preparar-manzana-de-una
    (declare (salience 10))
    ?f <- (robot linea-pedido $?x palet naranja ?cajasNaranja manzana ?cajasManzana $?y)
    ?f2 <- (pedido $?z manzana ?pedidoManzana $?k)
    ?f3 <- (maximo-cajas ?maxCajas)
    (test (<= ?cajasFruta ?maxCajas))
    =>
    assert((robot linea-pedido $?x pedido manzana ?pedidoManzana palet naranja ?cajasNaranja palet manzana (- ?cajasManzana ?pedidoManzana) $?y))
)

(defrule preparar-caqui-de-una
    (declare (salience 10))
    ?f <- (robot linea-pedido $?x palet naranja ?cajasNaranja palet manzana ?cajasManzana palet caqui ?cajasCaqui $?y)
    ?f2 <- (pedido naranja ?pedidoNaranja manzana ?pedidoManzana caqui ?pedidoCaqui uva ?pedidoUva)
    ?f3 <- (maximo-cajas ?maxCajas)
    (test (<= ?cajasFruta ?maxCajas))
    =>
    assert((robot linea-pedido pedido naranja ?pedidoNaranja pedido manzana ?pedidoManzana pedido caqui ?pedidoCaqui palet naranja (- ?cajasNaranja ?pedidoNaranja) palet manzana ?cajasManzana palet caqui (- ?cajasCaqui ?pedidoCaqui) $?y))
)

(defrule preparar-uva-de-una
    (declare (salience 10))
    ?f <- (robot linea-pedido $?x palet naranja ?cajasNaranja palet manzana ?cajasManzana palet caqui ?cajasCaqui palet uva ?cajasUva $?y)
    ?f2 <- (pedido naranja ?pedidoNaranja manzana ?pedidoManzana caqui ?pedidoCaqui uva ?pedidoUva)
    ?f3 <- (maximo-cajas ?maxCajas)
    (test (<= ?cajasFruta ?maxCajas))
    =>
    assert((robot linea-pedido pedido naranja ?pedidoNaranja palet naranja (- ?cajasNaranja ?pedidoNaranja) palet manzana ?cajasManzana palet caqui ?cajasCaqui palet uva ?cajasUva))
)

(defrule inicializar-stock
    (declare (salience 100))

    ?f <- (stock cajas naranja ?stockNaranja manzana ?stockManzana caqui ?stockCaqui uva ?stockUva)
    ?f2 <- (robot linea-pedido palet naranja ?inicio palet manzana ?inicio palet caqui ?inicio palet uva ?inicio)
    =>
    (assert (robot linea-pedido palet naranja ?stockNaranja palet manzana ?stockManzana palet caqui ?stockCaqui palet uva ?stockUva))
)

(defrule finalizar-pedido
    (declare (salience 50))

    (robot linea-pedido palet naranja ?cajasNaranja palet manzana ?cajasManzana palet caqui ?cajasCaqui palet uva ?cajasUva)
    (pedido naranja ?cajasNaranja manzana ?cajasManzana caqui ?cajasCaqui uva ?cajasUva)
    =>
    (printout t "Pedido preparado")
    (printout t "Cajas: Naranjas: " ?cajasNaranja ", Manzanas: " ?cajasManzana ", Caquis: " ?cajasCaqui ", Uvas: " ?cajasUva)
    (halt)
)

(defrule pedido-no-se-puede-hacer
    (declare (salience 50))
    (pedido naranja ?cajasNaranja manzana ?cajasManzana caqui ?cajasCaqui uva ?cajasUva)
    (stock cajas naranja ?stockNaranja manzana ?stockManzana caqui ?stockCaqui uva ?stockUva)
    (test (or (> ?cajasNaranja ?stockNaranja)(> ?cajasManzana ?stockManzana)(> ?cajasCaqui ?stockCaqui)(> ?cajasUva ?stockUva)))
    =>
    (printout t "El pedido no se puede realizar, no hay tanto stock")
    (halt)
)
