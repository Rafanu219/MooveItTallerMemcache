Para correr el server debemos ejecutar el comando ruby server.rb estando en la carpeta app.
Luego ejecutar en una terminal telnet localhost 2000

Para correr un demo client debemos ejecutar el server primero y despues ejecutar el comando ruby client.rb

Para probar el memcache debemos hacerlo luego de ejecutar el server y conectarse a telnet localhost 2000

Desde ahi podemos probar las funcionalidades de memcache por ejemplo:

set Jhon 1 800 3
Doe

Mensaje esperado : STORED
___________________________________________________
add Jane 2 800 3
Doe

Mensaje esperado:STORED
___________________________________________________
replace Jhon 2 800 6
Garcia

Mensaje esperado:STORED
___________________________________________________
append Jane 2 800 7
 Garcia

Mensaje esperado:STORED
___________________________________________________
prepend Jhon 1 800 4
Doe <-- deje un espacio despues de doe

Mensaje esperado:STORED
___________________________________________________
get Jhon

Mensaje esperado:
VALUE Jhon 2 10
Doe Garcia
END
___________________________________________________
gets Jane

Mensaje esperado:
VALUE Jane 2 10 4
Doe Garcia
___________________________________________________
cas Jane 1 800 3 4
Doe

Mensaje esperado:
STORED
___________________________________________________
get Jane

Mensaje esperado:
VALUE Jane 1 3
Doe
END
___________________________________________________

Finalmente para correr los test hay que ejecutar el comando rspec con la gema rspec instalada


Decisiones a tener en cuenta:

Dado a que se pidio simular el comportamiento de un memcache intente mantener sus comandos exactos y el comportamiento de ellos.

Algo que si cambie son algunos de los mesajes de error dado a que son muy poco informativos, decidi dar mensajes que expliquen un poco el error que esta sucediendo.

Al programar append y prepend me di cuenta que piden flag y bits y no los modifican, por lo tanto me pareceria bueno sacarlos del comando, pero al estar simulando el comportamiendo de un memache decidi dejarlos.
