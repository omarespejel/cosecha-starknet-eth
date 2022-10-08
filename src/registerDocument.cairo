%lang starknet


from starkware.cairo.common.uint256 import Uint256, uint256_add
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem, split_felt
from starkware.cairo.common.cairo_secp.bigint import BigInt3
from starkware.cairo.common.alloc import alloc


from openzeppelin.access.ownable.library import Ownable
from openzeppelin.introspection.erc165.library import ERC165
from openzeppelin.token.erc721.library import ERC721

// ------
// Constructor
// ------

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    oracle_addr: felt, _beacon_address: felt
) {
    alloc_locals;
    // "L2 coleccion octubre"
    let name = 435001157271749608490168255869766614643032355429;
    // "BBB"
    let symbol = 4342338;
    let owner = 1268012686959018685956609106358567178896598707960497706446056576062850827536;

    let base_token_uri_len = 3;
    let (base_token_uri: felt*) = alloc();
    // "https://gateway.pinata.cloud/ip"
    assert base_token_uri[0] = 184555836509371486644298270517380613565396767415278678887948391494588524912;
    // "fs/QmZLkgkToULVeKdbMic3XsepXj2X"
    assert base_token_uri[1] = 181013377130050200990509839903581994934108262384437805722120074606286615128;
    // "xxMukhUAUEYzBEBDMV/"
    assert base_token_uri[2] = 2686569255955106314754156739605748156359071279;

    // .jpeg
    let token_uri_suffix = 1199354246503;

    token_counter.write(Uint256(0,0));
    ERC721.initializer(name, symbol);
    Ownable.initializer(owner);
    // set_base_tokenURI(base_token_uri_len, base_token_uri, token_uri_suffix);

    // Requirements for randomness
    oracle_address.write(oracle_addr);
    beacon_address.write(_beacon_address);

    return ();
}

// ------
// Getters
// ------

@view
func owner{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (owner: felt) {
    return Ownable.owner();
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