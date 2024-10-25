// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


//name of contract
contract ApplicantHub{
    //Used constant on the state variable to manage gas
    string constant Requirements = "name, Country, Years of Experience, Wallet Address, Few details about you";

    //returns the requirements needed
    function getRequirements() public pure returns (string memory){
        return Requirements;
    }

   //Used struct to group similar data needed
    struct JobSeekerDetails{
        string name;
        string country;
        uint256 YearsOfExp;
        address YourWalletAddr;
        string YourDetails;
    }

    //deployer address is the owner
    address public onlyOwner;

     constructor () {
        onlyOwner = msg.sender;
    }

    //Created an array to store each applicant's details and set visibility to private (so only the contract owner has access to it) + mapping
    JobSeekerDetails[] private SeekersArchive;
    mapping(string => JobSeekerDetails) private ApplicantName;

    //Function that allows applicants to fill in necessary info
    function addApplicant(string memory _name, string memory _country, uint256 _YearsOfExp, address _YourWalletAddr, string memory _YourDetails) public{
    
    /*Adding require before pushing an applicant to the array and before mapping helps manage gas so it will check if the applicant meets the 
    necessary requirements before executing the remaining code*/
    require(bytes(_name).length > 2 ,"Applicant Name can only have more than 2 charatcer");
    require(_YourWalletAddr != address(0), "Input Legit Wallet Address");
    require(_YearsOfExp >= 3, "Years Of Experience Must Be greater than 2");

    SeekersArchive.push(JobSeekerDetails(_name, _country, _YearsOfExp, _YourWalletAddr, _YourDetails)); /*push the applicant details to the array*/
    ApplicantName[_name] = JobSeekerDetails(_name,  _country, _YearsOfExp, _YourWalletAddr, _YourDetails); /* Use applicant name to retrieve applicant details*/


    }
    //function to allow only owner to get the applicant details via name
    function getApplicantName(string memory _name) public view onlyOwnerAccess returns (JobSeekerDetails memory){
        return ApplicantName[_name];
    }
     //function to allow only owner to get the applicant details via index
    function getSeekersArchive() public view onlyOwnerAccess returns (JobSeekerDetails[] memory){
        return SeekersArchive;
    }

    //Modifier for creating access control with a custom message
    modifier onlyOwnerAccess{
        require(onlyOwner == msg.sender, "Only HR can retrieve Applicant Details");
        _;
    }
}