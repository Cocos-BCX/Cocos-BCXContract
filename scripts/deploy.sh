echo "deploy begin....."

TF_CMD=node_modules/.bin/truffle-flattener


echo "" >  ./deployments/PlayerBookBSC.full.sol
cat  ./scripts/head.sol >  ./deployments/PlayerBookBSC.full.sol
$TF_CMD ./contracts/referral/PlayerBookBSC.sol >>  ./deployments/PlayerBookBSC.full.sol 

echo "" >  ./deployments/PlayerBook.full.sol
cat  ./scripts/head.sol >  ./deployments/PlayerBook.full.sol
$TF_CMD ./contracts/referral/PlayerBook.sol >>  ./deployments/PlayerBook.full.sol 

# echo "" >  ./deployments/PlayerBookReward.full.sol
# cat  ./scripts/head.sol >  ./deployments/PlayerBookReward.full.sol
# $TF_CMD ./contracts/referral/PlayerBookReward.sol >>  ./deployments/PlayerBookReward.full.sol 


echo "" >  ./deployments/PlayerBookProxy.full.sol
cat  ./scripts/head.sol >  ./deployments/PlayerBookProxy.full.sol
$TF_CMD ./contracts/referral/PlayerBookProxy.sol >>  ./deployments/PlayerBookProxy.full.sol 

echo "deploy end....."