
circom circuit.circom -r circuit.r1cs -w circuit.wasm -s circuit.sym
wget https://storage.googleapis.com/zkevm/ptau/powersOfTau28_hez_final_22.ptau
snarkjs plonk setup circuit.r1cs pot14_final.ptau circuit_final.zkey
cd circuit_js
node generate_witness.js circuit.wasm ../input.json ../witness.wtns
cd ..
snarkjs wtns check circuit.r1cs witness.wtns
snarkjs zkey verify circuit.r1cs powersOfTau28_hez_final_22.ptau circuit_final.zkey
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json
snarkjs plonk prove circuit_final.zkey witness.wtns proof.json public.json
snarkjs plonk verify verification_key.json public.json proof.json
snarkjs zkey export solidityverifier circuit_final.zkey verifier.sol
snarkjs zkey export soliditycalldata public.json proof.json


