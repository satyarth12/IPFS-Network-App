pragma solidity ^0.5.0;


contract ModifierContract{
    string public name;

    constructor() public {
        name = "Modifier Contract, only for checking requirements";
    }

    modifier uploadFileReqs(
        string memory _fileHash,
        uint256 _fileSize,
        string memory _fileType,
        string memory _fileName,
        string memory _fileDescription
    ) {
        require(bytes(_fileHash).length > 0);
        require(bytes(_fileType).length > 0);
        require(bytes(_fileName).length > 0);
        require(bytes(_fileDescription).length > 0);

        require(msg.sender != address(0));
        require(_fileSize > 0);
        _;
    }
}




contract DStorage is ModifierContract{
    string public name;
    uint256 public fileCount = 0;

    struct File {
        uint256 fileId;
        string fileHash;
        uint256 fileSize;
        string fileType;
        string fileName;
        string fileDescription;
        uint256 uploadTime;
        address payable uploader;
    }

    // for mapping file number to their corresponding hash
    mapping(uint256 => File) public files;

    event FileUploaded(
        uint256 fileId,
        string fileHash,
        uint256 fileSize,
        string fileType,
        string fileName,
        string fileDescription,
        uint256 uploadTime,
        address payable uploader
    );

    constructor() public {
        name = "Decentralized Storage Box";
    }

    function uploadFile(
        string memory _fileHash,
        uint256 _fileSize,
        string memory _fileType,
        string memory _fileName,
        string memory _fileDescription
    ) public uploadFileReqs(_fileHash, _fileSize, _fileType, _fileName, _fileDescription) {

        fileCount++;
        files[fileCount] = File(fileCount, _fileHash, _fileSize, _fileType, _fileName, _fileDescription, now, msg.sender);

        emit FileUploaded(
            fileCount, _fileHash, _fileSize, _fileType, _fileName, _fileDescription, now, msg.sender
        );
    }
}
