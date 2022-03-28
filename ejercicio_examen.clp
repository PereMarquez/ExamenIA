(deffacts datos
    (stock cajas naranja 5 manzana 5 caqui 5 uva 5)
    (robot linea-pedido palet naranja 0 palet manzana 0 palet caqui 0 palet uva 0)
    (pedido naranja 3 manzana 1 caqui 2 uva 4)
    (maximo-cajas 3)
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

    (robot linea-pedido pedido naranja ?pedidoNaranja pedido manzana ?pedidoManzana pedido caqui ?pedidoCaqui pedido uva ?pedidoUva $?x)
    (pedido naranja ?pedidoNaranja manzana ?pedidoManzana caqui ?pedidoCaqui uva ?pedidoUva)
    =>
    (printout t "Pedido preparado")
    (printout n "Cajas: Naranjas: " ?pedidoNaranja ", Manzanas: " ?pedidoManzana ", Caquis: " ?pedidoCaqui ", Uvas: " ?pedidoUva)
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

(defrule preparar-naranja-de-una
    ?f <- (robot linea-pedido $?x palet naranja ?cajasNaranja $?y)
    ?f2 <- (pedido naranja ?pedidoNaranja $?z)
    ?f3 <- (maximo-cajas ?maxCajas)
    (test (< ?pedidoNaranja ?cajasNaranja))
    =>
    (assert(robot linea-pedido $?x pedido naranja ?pedidoNaranja palet naranja (- ?cajasNaranja ?pedidoNaranja) $?z))
)

(defrule preparar-manzana-de-una
    ?f <- (robot linea-pedido $?x palet naranja ?cajasNaranja manzana ?cajasManzana $?y)
    ?f2 <- (pedido $?z manzana ?pedidoManzana $?k)
    ?f3 <- (maximo-cajas ?maxCajas)
    (test (< ?pedidoManzana ?cajasManzana))
    =>
    (assert(robot linea-pedido $?x pedido manzana ?pedidoManzana palet naranja ?cajasNaranja palet manzana (- ?cajasManzana ?pedidoManzana) $?y))
)

(defrule preparar-caqui-de-una
    ?f <- (robot linea-pedido $?x palet naranja ?cajasNaranja palet manzana ?cajasManzana palet caqui ?cajasCaqui $?y)
    ?f2 <- (pedido naranja ?pedidoNaranja manzana ?pedidoManzana caqui ?pedidoCaqui uva ?pedidoUva)
    ?f3 <- (maximo-cajas ?maxCajas)
    (test (< ?pedidoCaqui ?cajasCaqui))
    =>
    (assert(robot linea-pedido $?x pedido caqui ?pedidoCaqui palet naranja ?cajasNaranja palet manzana ?cajasManzana palet caqui (- ?cajasCaqui ?pedidoCaqui) $?y))
)

(defrule preparar-uva-de-una
    ?f <- (robot linea-pedido $?x palet naranja ?cajasNaranja palet manzana ?cajasManzana palet caqui ?cajasCaqui palet uva ?cajasUva $?y)
    ?f2 <- (pedido naranja ?pedidoNaranja manzana ?pedidoManzana caqui ?pedidoCaqui uva ?pedidoUva)
    ?f3 <- (maximo-cajas ?maxCajas)
    (test (< ?pedidoUva ?cajasUva))
    =>
    (assert(robot linea-pedido $?x pedido uva ?pedidoUva palet naranja ?cajasNaranja palet manzana ?cajasManzana palet caqui ?cajasCaqui palet uva (- ?cajasUva ?pedidoUva) $?y))
)


