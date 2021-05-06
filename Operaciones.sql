--ACTUALIZAR PRECIO DE PRODUCTOS
set serveroutput on;
CREATE OR REPLACE PROCEDURE actualizar_precio_producto
(codigo_producto IN CHAR,nuevo_precio IN NUMBER)
IS
BEGIN 
    UPDATE productos SET precio_unitario = nuevo_precio
    WHERE cod_producto = codigo_producto;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se actualizo el precio de manera correcta');

EXCEPTION 
   WHEN OTHERS THEN
    ROLLBACK;
END actualizar_precio_producto;   
   
 select * from productos;  

--llamada al SP
CALL actualizar_precio_producto('P0007',34);

--cursor 
CREATE OR REPLACE PROCEDURE clientes_sinfactura
IS 
CURSOR report_cursor IS
  SELECT cod_cliente,nombres FROM clientes WHERE cod_cliente NOT IN  (SELECT distinct(cod_cliente) FROM facturas);
BEGIN 
 DBMS_OUTPUT.PUT_LINE('LISTA DE CLIENTES SIN FACTURA');
 FOR rep IN report_cursor
 LOOP
 DBMS_OUTPUT.PUT_LINE(RPAD(rep.cod_cliente,8)||rep.nombres);
 END LOOP;

END  clientes_sinfactura;

--EXECUTION
CALL clientes_sinfactura();


CREATE OR REPLACE FUNCTION producto_mas_vendido
RETURN VARCHAR2
IS 
 product_name VARCHAR2(30);
 CURSOR report is
 SELECT p.descripcion "producto"
 FROM detalle_facturas fd
 INNER JOIN productos p ON fd.cod_producto=p.cod_producto
 GROUP BY p.descripcion
 ORDER BY SUM(fd.cantidad) DESC
 FETCH NEXT 1 ROWS ONLY;
 
 BEGIN 
   OPEN report;
   FETCH report INTO product_name;
   RETURN product_name;
 END producto_mas_vendido;
    
----
SELECT producto_mas_vendido FROM dual;


---TRIGGER QUE MODIFICAR EL TOTAL DE UNA FACTURA SI SE ELIMINA O ACTUALIZA ALGO DEL DETALLE
CREATE OR REPLACE TRIGGER actualiza_factura
BEFORE INSERT OR DELETE ON detalle_facturas
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    UPDATE facturas SET importe_total = importe_total + :new.subtotal WHERE cod_factura = :new.cod_factura;
  END IF;
   
  IF DELETING THEN
    UPDATE facturas SET importe_total = importe_total - :old.subtotal WHERE cod_factura = :old.cod_factura;
  END IF;
 
END actualiza_factura;