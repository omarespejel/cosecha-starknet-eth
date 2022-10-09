%lang starknet


from starkware.cairo.common.uint256 import Uint256, uint256_add
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem, split_felt
from starkware.cairo.common.alloc import alloc


from openzeppelin.access.ownable.library import Ownable
from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.token.erc721.library import ERC721

// ------
// Structs
// ------

struct UserInfo {
    name: felt,
    last_name: felt,
    id_cedula: felt,
    application_number: felt,
    already_approved: felt,
    licence_number: felt,
    accepting_collaborations: felt,
}


// ------
// Storage
// ------

@storage_var
func token_counter() -> (number: Uint256) {
}

@storage_var
func id_to_user_info(id: felt) -> (user_info: UserInfo) {
}


// ------
// Constructor
// ------

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    oracle_addr: felt, _beacon_address: felt
) {
    alloc_locals;
    // "marihuanaETH"
    let name = 435001157271749608490168255869766614643032355429;
    // "XXX"
    let symbol = 4342338;
    let owner = 1268012686959018685956609106358567178896598707960497706446056576062850827536;

    token_counter.write(Uint256(0,0));
    ERC721.initializer(name, symbol);
    Ownable.initializer(owner);

    return ();
}

// ------
// Getters
// ------

@view
func get_number_of_users_registered{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (tokenID: Uint256) {
    let last_token : Uint256 = token_counter.read();
    return (tokenID=last_token);
}

@view
func get_user_info{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(id_cedula: felt) -> (info: UserInfo) {
    let last_token : Uint256 = token_counter.read();
    return (tokenID=last_token);
}


// ------
// Non-Constant Functions: state-changing functions
// ------

@external
func create_collectible{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    // password: felt
) {

    // with_attr error_message("Create Collectible: Wrong password") {
    //     assert PASSWORD = password;
    // }

    let (requestID: felt) = request_rng();
    let (caller_address: felt) = get_caller_address();
    
    request_id_to_sender.write(requestID, caller_address);
    // request_id_to_tokenURI.write(requestID, tokenURI);
    return();
}

@external
func register_yourself{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    name: felt, last_name: felt, id_cedula: felt, application_number: felt
) -> () {

    let user_info : UserInfo = UserInfo(
                                    name=name,
                                    last_name=last_name,
                                    id_cedula=id_cedula,
                                    application_number=register_number,
                                    already_approved=0,
                                    licence_number=0,
                                    accepting_collaborations=0
                                    );

    let (caller_address: felt) = get_caller_address();

    id_to_user_info.write(UserInfo.id_cedula, user_info);

    // Update new tokenID
    let last_token : Uint256 = token_counter.read();
    let one_uint : Uint256 = Uint256(1,0);
    let (new_tokenID, _ ) = uint256_add(a=last_token, b=one_uint);
    token_counter.write(new_tokenID);

    // Mint
    ERC721._mint(to=caller_address, token_id=new_tokenID);

    return();
}

@external
func register_yourself{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    name: felt, last_name: felt, id_cedula: felt, application_number: felt
) -> () {

    let user_info : UserInfo = UserInfo(
                                    name=name,
                                    last_name=last_name,
                                    id_cedula=id_cedula,
                                    application_number=register_number,
                                    already_approved=0,
                                    licence_number=0,
                                    accepting_collaborations=0
                                    );

    let (caller_address: felt) = get_caller_address();
    address_to_user_info.write(caller_address, user_info);

    // Update new tokenID
    let last_token : Uint256 = token_counter.read();
    let one_uint : Uint256 = Uint256(1,0);
    let (new_tokenID, _ ) = uint256_add(a=last_token, b=one_uint);
    token_counter.write(new_tokenID);

    // Mint
    ERC721._mint(to=caller_address, token_id=new_tokenID);

    return();
}

@external
func got_my_license_approved{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    licence_number: felt, accepting_collaborations: felt
) {
    // TODO - check user is registered

    // Change user info to reflect the approval of the license
    let (caller_address: felt) = get_caller_address();
    let user_info : UserInfo = address_to_user_info.read(caller_address);

    user_info.already_approved = 1;
    user_info.licence_number = licence_number;
    user_info.accepting_collaborations = accepting_collaborations;
    address_to_user_info.write(caller_address, user_info);
    
}