pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BEP20Basic is IERC20 {
    string public name;
    string public symbol;
    uint8 public constant decimals = 18;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;

    uint256 _totalsupply = 1000000 * 10 ** 18; // 100mln

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        _mint(_totalSupply);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(
        address tokenOwner
    ) public view override returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(
        address receiver,
        uint256 numTokens
    ) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - numTokens;
        balances[receiver] = balances[receiver] + numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(
        address delegate,
        uint256 numTokens
    ) public override returns (bool) {
        allowances[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(
        address owner,
        address delegate
    ) public view override returns (uint) {
        return allowances[owner][delegate];
    }

    function transferFrom(
        address owner,
        address buyer,
        uint256 numToken
    ) public override returns (bool) {
        require(numToken <= balances[owner]);
        require(numToken <= allowances[owner][msg.sender]);

        balances[owner] = balances[owner] - numToken;
        allowances[owner][msg.sender] =
            allowances[owner][msg.sender] -
            numToken;
        balances[buyer] = balances[buyer] + numToken;

        emit Transfer(owner, buyer, numToken);
        return true;
    }

    function _mint(uint amount) internal {
        balances[msg.sender] = balances[msg.sender] + amount;
        _totalSupply = _totalSupply + amount;
        emit Transfer(address(0), msg.sender, amount);
    }
}
