### [H-#] The teachers wage are changed on LevelTwo implementation modiffying the payment standard.

**Description:**\
On LevelTwo implementation, are a not suppoused update on teachers wage from 35% to 40%

<details>

LevelOne.sol
```javascript
    uint256 public constant TEACHER_WAGE = 35; // 35%
    uint256 public constant PRINCIPAL_WAGE = 5; // 5%
```
LevelTwo.sol
```javascript
@>  uint256 public constant TEACHER_WAGE_L2 = 40; // 40%
    uint256 public constant PRINCIPAL_WAGE_L2 = 5; // 5%
```
</details>

**Impact:**\
The payment standard will broken.

**Recommended Mitigation:**\
Change the `TEACHER_WAGE_L2` to "35" on `LevelTwo.sol`, or redefine the payment standard.

### [H-#] Missing access control on `LevelOne::initialize` get exposed to MEV attack

**Description:**\
The function who initialize the proxy implementation `LevelOne::initialize` haven't any access control, making possible a MEV attack because an attacker can call `LevelOne::initialize` first.

**Impact:**\
The attacker got the full control of the protocol controling who is the Principal

**Proof of Concept:**\
<details>

```text
User Deploy proxy
    |
User Deploy LevelOne
    |
    |--->**Attacker call LevelOne::initialize()** ---> (Attacker control the protocol)
    |
User call LevelOne::initialize ---> User Rejected
```

**Recommended Mitigation:**\
Use Ownable library for UUPS of openzeppelin


