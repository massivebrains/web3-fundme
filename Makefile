include .env

.PHONY: test deploy send

DEFAULT_RPC_URL = http://127.0.0.1:8545
DEFAULT_ANVIL_SENDER = 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266

test:
	forge test

deploy:
	forge script script/DeploySimpleStorage.s.sol --rpc-url=$(DEFAULT_RPC_URL) --broadcast -vvvv --account defaultKey --sender $(DEFAULT_ANVIL_SENDER)

send:
	cast send 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 "store(uint256)" 123 --rpc-url=$(DEFAULT_RPC_URL) --private-key $(PRIVATE_KEY)
