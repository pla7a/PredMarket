async function main() {
  // We get the contract to deploy
  const Yes = await ethers.getContractFactory("Yes");
  const yes = await Yes.deploy("InvadeYES", "INVY");
  console.log("Yes deployed to:", yes.address);

  const No = await ethers.getContractFactory("No");
  const no = await No.deploy("InvadeNO", "INVN");
  console.log("No deployed to:", no.address);

  const Indet = await ethers.getContractFactory("Indet");
  const indet = await Indet.deploy("InvadeIndet", "INVI");
  console.log("Indet deployed to:", indet.address);

  const MintSet = await ethers.getContractFactory("MintSet");
  const mintset = await MintSet.deploy('0x4DBCdF9B62e891a7cec5A2568C3F4FAF9E8Abe2b', yes.address, no.address, indet.address);
  console.log("MintSet deployed to:", mintset.address);

  const Redeem = await ethers.getContractFactory("Redeem");
  const redeem = await Redeem.deploy('1', mintset.address);
  console.log("Redeem deployed to:", String(redeem.address));

  const msRedeemer = await mintset.setRedeemer(redeem.address);
  console.log('Done');

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
