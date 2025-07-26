# Deploy to local anvil
deploy-local:
	forge script script/DeployCrowdfunding.s.sol --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast

# Deploy to Sepolia testnet  
deploy-sepolia:
	forge script script/DeployCrowdfunding.s.sol --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY)

# Start local anvil node
anvil:
	anvil

# Build the project
build:
	forge build

# Run tests
test:
	forge test

# Run tests with verbosity
test-v:
	forge test -vv

# Clean build artifacts
clean:
	forge clean

# Format code
fmt:
	forge fmt

# Check gas usage
gas:
	forge test --gas-report
