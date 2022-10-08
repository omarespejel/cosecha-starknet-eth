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

from src.interfaces.IRNGOracle import IRNGOracle
from src.utils.array import concat_arr
from src.utils.metadata_utils import set_base_tokenURI, ERC721_Metadata_tokenURI

// ------
// Constants
// ------

// const PASSWORD = 654;

// ------
// Storage
// ------

@storage_var
func oracle_address() -> (addr: felt) {
}

@storage_var
func beacon_address() -> (address: felt) {
}

@storage_var
func rn_request_id() -> (id: felt) {
}

@storage_var
func request_id_to_tokenId(rn_request_id: felt) -> (tokenId: Uint256) {
}

@storage_var
func request_id_to_sender(rn_request_id: felt) -> (address: felt) {
}

@storage_var
func request_id_to_tokenURI(rn_request_id: felt) -> (tokenURI: felt) {
}

@storage_var
func token_counter() -> (number: Uint256) {
}

@storage_var
func tokenID_to_random_number(tokenID: Uint256) -> (number: felt) {
}

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

@view
func ownerOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenId: Uint256) -> (
    owner: felt
) {
    return ERC721.owner_of(tokenId);
}

@view
func get_last_tokenID{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (tokenID: Uint256) {
    let last_token : Uint256 = token_counter.read();
    return (tokenID=last_token);
}

@view
func get_random_number{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(tokenID: Uint256) -> (number: felt) {
    let number : felt = tokenID_to_random_number.read(tokenID);
    return (number=number);
}

@view
func tokenURI{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    token_id: Uint256
) -> (token_uri_len: felt, token_uri: felt*) {
    let random_number : felt = tokenID_to_random_number.read(token_id);
    let (token_uri_len, token_uri) = ERC721_Metadata_tokenURI(token_id, random_number);
    return (token_uri_len=token_uri_len, token_uri=token_uri);
}

@view
func get_current_random_requestID{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (request_id: felt) {
    let request_id : felt = rn_request_id.read();
    return (request_id=request_id);
}

@view
func get_sender_random_requestID{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (caller: felt) {
    let request_id : felt = rn_request_id.read();
    let caller : felt = request_id_to_sender.read(request_id);
    return (caller=caller);
}




// ------
// Constant Functions: non state-changing functions
// ------



// set the random value corresponding to the NFT as URI
// @external
// func setTokenURI{pedersen_ptr: HashBuiltin*, syscall_ptr: felt*, range_check_ptr}(
//     tokenId: Uint256, tokenURI: felt
// ) {
//     Ownable.assert_only_owner();
//     ERC721._set_token_uri(tokenId, tokenURI);
//     return ();
// }

func create_random_number{syscall_ptr: felt*, range_check_ptr}(rng: felt) -> (roll: felt) {
    // Take the lower 128 bits of the random string
    let (_, low) = split_felt(rng);
    let (_, number) = unsigned_div_rem(low, 10);
    return (number + 1,);
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

// @external
func request_rng{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    request_id: felt
) {
    let (oracle) = oracle_address.read();
    let (_beacon_address) = beacon_address.read();
    let (request_id) = IRNGOracle.request_rng(
        contract_address=oracle, beacon_address=_beacon_address
    );
    rn_request_id.write(request_id);
    return (request_id,);
}

// Function called by the oracle
@external
func will_recieve_rng{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    rng: BigInt3, request_id: felt
) {
    // Assert the caller is the oracle
    let (oracle) = oracle_address.read();
    let (caller_address) = get_caller_address();
    assert oracle = caller_address;

    // Get new nft owner address and the tokenURI for this random request
    // Each nft owner has a random request map to they
    let (nft_owner: felt) = request_id_to_sender.read(request_id);
    // let (tokenURI: felt) = request_id_to_tokenURI.read(request_id);
    // xxx replace, this is while we set URI
    // let tokenURI: felt = 2;

    // Update new tokenID
    let last_token : Uint256 = token_counter.read();
    let one_uint : Uint256 = Uint256(1,0);
    let (new_tokenID, _ ) = uint256_add(a=last_token, b=one_uint);
    token_counter.write(new_tokenID);

    // Mint to nft owner and set the URI of the tokenID
    ERC721._mint(to=nft_owner, token_id=new_tokenID);
    // ERC721._set_token_uri(token_id=new_tokenID, token_uri=tokenURI);

    // Set random number corresponding to the tokenID
    let (random_number) = create_random_number(rng.d0);
    tokenID_to_random_number.write(new_tokenID, random_number);
    
    // Save random number obtained
    // rn_number.write(random_number);

    // Map request id to tokenID
    request_id_to_tokenId.write(request_id, new_tokenID);

    // rng_request_resolved.emit(rng, request_id, roll);
    return ();
}