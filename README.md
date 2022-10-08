

## Proceso
1. Persona que quiere tramitar su licencia para marihuana sube inicia sesión con su wallet.
2. Sube su documento y se firma con la wallet. El documento queda guardado con IPFS.
3. Este documento puede ser buscando posteriormente. 
4. Cuando tenga su licencia por parte del gobierno, se sube la licencia.
5. Es importante tener un catalogo adecuado de quien tiene licencia.

## Lógica del smart contract
1. El usuario puede llamar la variable external `create_license(register_number: felt, name: felt, last_name: felt, id: felt) -> ()`. En el argumento register_number registra el número de registro de su aplicación, su nombre, su apellido y su cédula. Está información se guarda en un struct `UserInfo` con los members `register_number, name, last_name, id, already_approved, licence_number, accepting_collaborations`. Inicialmente `already_approved, licence_number, accepting_collaborations` tienen un 0 pues el usuario se está registrando.
   1. Se crea storage variable `address_to_user_info(address: felt) -> (user_info: UserInfo)`
   2. Se escribe en la variable de storage `user_to_application(address: felt) -> (registration_number: felt)` para registrar el que está persona tiene un registro en proceso.
   3. El getter `get_registration_number(address: felt) -> (registration_number: felt)` muestra si el usuario tiene un registro o no tiene.
   4. Se escribe en la variable de storage `application_to_user(registration_number: felt) -> (address: felt)` para registrar a quién pertenece un registro en proceso.
   5. Se crea `tokenID` que comienza en cero y lleva la cuenta de los registros hechos. Se crea la storage variable `tokenID_to_user(tokenID: Uint256) -> (address: felt)` y el getter `get_user_from_tokenID(tokenID: Uint256) -> (address: felt)`.
   6. Se llama `ERC721._mint(to=caller, token_id=new_tokenID)`. Con esto el usuario se vuelve owner del equivalente a un collectible en su billetera.
2. Una vez que el usuario tenga la licencia aprobada puede llamar la variable external `got_my_license_approved(licence_number: felt, accepting_collaborations: felt)`. Está función registra en el struct `UserInfo.already_approved` y en `UserInfo.licence_number` un 1 y en `UserInfo.license_number` el numero de la licencia nueva.    
3. Identificación con nombre, apellido y cédula.
4. Capacidad de inicializar un documento indicando el sitio en IPFS donde se encuentra.
5. El gobierno da una licencia y la misma persona puede registrar que ya tiene licencia.
6. Hay un contrato maestro que indica quiénes ya tienen licencia