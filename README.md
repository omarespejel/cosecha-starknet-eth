

## Proceso
1. Persona que quiere tramitar su licencia para marihuana sube inicia sesión con su wallet.
2. Sube su documento y se firma con la wallet. El documento queda guardado con IPFS.
3. Este documento puede ser buscando posteriormente. 
4. Cuando tenga su licencia por parte del gobierno, se sube la licencia.
5. Es importante tener un catalogo adecuado de quien tiene licencia.

## Lógica del smart contract
1. El usuario puede dar `create_license(register_number : felt)`. En el argumento register_number registra el número de registro de su aplicación.
   1. Se escribe en la variable de storage `user_to_application(address: felt) -> (registration_number: felt)` para registrar el que está persona tiene un registro en proceso.
   2. El getter `get_registration_number(address: felt) -> (registration_number: felt)` muestra si el usuario tiene un registro o no tiene.
   3. Se escribe en la variable de storage `application_to_user(registration_number: felt) -> (address: felt)` para registrar a quién pertenece un registro en proceso.
   4. Se crea tokenID que comienza en cero y lleva la cuenta de los registros hechos. Se crea la storage variable 
   5. Se llama `ERC721._mint(to=caller, token_id=new_tokenID)`;
2. Con esto el usuario se vuelve owner del equivalente a un collectible en su billetera.
3. Un owner de la licencia.
4. Identificación con nombre, apellido y cédula.
5. Capacidad de inicializar un documento indicando el sitio en IPFS donde se encuentra.
6. El gobierno da una licencia y la misma persona puede registrar que ya tiene licencia.
7. Hay un contrato maestro que indica quiénes ya tienen licencia