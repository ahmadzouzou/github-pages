unit wincrypt;
// stripped down version of WINCRYPT.H used for procedure calls in main program
// all that is intended is to be able to support file hashing, though wincrypt
// supports encryption and key exchange.
// 11-29-2011 - added information to use the CSPRNG in the crypto API.
// 10-30-2012 - added information to access SHA256, SHA384, SHA512.
// 01-04-2013 - added information to access Base64 encode/decode.
// 01-22-2013 - added information relating to some password based encryption stuff.

interface

uses
	windows;

const
	advapi='ADVAPI32.DLL';
	PROV_RSA_FULL=1;
	PROV_RSA_AES=24;
	CRYPT_VERIFYCONTEXT=$F0000000;
	CRYPT_NEWKEYSET=$00000008;
	// algo class ids
	ALG_CLASS_HASH=4 shl 13;
	ALG_TYPE_ANY=0;
	// Hash sub ids
	ALG_SID_MD2=1;
	ALG_SID_MD4=2;
	ALG_SID_MD5=3;
	ALG_SID_SHA=4;
	ALG_SID_SHA1=4;
	ALG_SID_MAC=5;
	ALG_SID_SSL3SHAMD5=8;
	ALG_SID_HMAC=9;
	ALG_SID_TLS1PRF=10;
	ALG_SID_HASH_REPLACE_OWF=11;
	// algorithm identifier definitions
	CALG_MD2=ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MD2;
	CALG_MD4=ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MD4;
	CALG_MD5=ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MD5;
	CALG_SHA=ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA;
	CALG_SHA1=ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA1;
	CALG_MAC=ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MAC;
	CALG_SSL3_SHAMD5=ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SSL3SHAMD5;
	CALG_HMAC=ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_HMAC;
	CALG_TLS1PRF=ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_TLS1PRF;
	CALG_HASH_REPLACE_OWF=ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_HASH_REPLACE_OWF;

	// some encryption algorithm definitions
	CALG_RC4=$00006801;
	CALG_RC5=$0000660D;
	CALG_3DES=$00006603;

	// use with PROV_RSA_AES To get SHA-2 values.
	CALG_SHA256=$0000800C;
	CALG_SHA384=$0000800D;
	CALG_SHA512=$0000800E;

	// gethashparam tags
	HP_ALGID=$0001;
	HP_HASHVAL=$0002;
	HP_HASHSIZE=$0004;
	HP_HMAC_INFO=$0005;
	HP_TLS1PRF_LABEL=$0006;
	HP_TLS1PRF_SEED=$0007;

	MS_ENHANCED_PROV:PAnsiChar='Microsoft Enhanced Cryptographic Provider v1.0';
	MS_ENHANCED_PROV_A:PAnsiChar='Microsoft Enhanced Cryptographic Provider v1.0';
	MS_ENHANCED_PROV_W:PWideChar='Microsoft Enhanced Cryptographic Provider v1.0';

	crypt32='crypt32.dll';
	CRYPT_STRING_BASE64HEADER=$00000000; // Base64, with certificate beginning and ending headers.
	CRYPT_STRING_BASE64=$00000001; // Base64, without headers.
	CRYPT_STRING_BINARY=$00000002; // Pure binary copy.
	CRYPT_STRING_BASE64REQUESTHEADER=$00000003; // Base64, with request beginning and ending headers.
	CRYPT_STRING_HEX=$00000004; // hexadecimal only.
	CRYPT_STRING_HEXASCII=$00000005; // Hexadecimal, with ASCII character display.
	// Tries the following, in order: CRYPT_STRING_BASE64HEADER    CRYPT_STRING_BASE64
	CRYPT_STRING_BASE64_ANY=$00000006;
	// Tries the following, in order: CRYPT_STRING_BASE64HEADER
	// CRYPT_STRING_BASE64    CRYPT_STRING_BINARY
	CRYPT_STRING_ANY=$00000007;
	CRYPT_STRING_HEX_ANY=$00000008;
	CRYPT_STRING_BASE64X509CRLHEADER=$00000009; // Base64, with X.509 CRL beginning and ending headers.
	CRYPT_STRING_HEXADDR=$0000000A; // Hexadecimal, with address display.
	CRYPT_STRING_HEXASCIIADDR=$0000000B; // Hexadecimal, with ASCII character and address display.
	CRYPT_STRING_HEXRAW=$0000000C; // A raw hexadecimal string.
	CRYPT_STRING_STRICT=$20000000; // Enforce strict decoding of ASN.1 text formats.
	CRYPT_STRING_NOCRLF=$40000000; // Do not append any new line characters to the encoded string.
	CRYPT_STRING_NOCR=$80000000; // Only use the line feed (LF) character (0x0A) for a new line.

type
	TCryptProv=THandle;
	TAlgID=integer;
	TCryptKey=pointer;
	TCryptHash=pointer;

function CryptAcquireContext(var phProv:TCryptProv;szContainer:PAnsiChar;szProvider:PAnsiChar;dwProvType:DWord;
	dwFlags:DWord):boolean;stdcall;
function CryptAcquireContextA(phProv:TCryptProv;szContainer:PAnsiChar;szProvider:PAnsiChar;dwProvType:DWord;
	dwFlags:DWord):boolean;stdcall;
function CryptAcquireContextW(phProv:TCryptProv;szContainer:PWideChar;szProvider:PWideChar;dwProvType:DWord;
	dwFlags:DWord):boolean;stdcall;
function CryptCreateHash(phProv:TCryptProv;Algid:TAlgID;hKey:TCryptKey;dwFlags:DWord;var phHash:TCryptHash)
	:boolean;stdcall;
function CryptHashData(phHash:TCryptHash;pbData:pointer;dwDataLen:DWord;dwFlags:DWord):boolean;stdcall;
function CryptGetHashParam(phHash:TCryptHash;dwParam:DWord;pbData:pointer;var dwDataLen:DWord;dwFlags:DWord)
	:boolean;stdcall;
function CryptDestroyHash(phHash:TCryptHash):boolean;stdcall;
function CryptReleaseContext(phProv:TCryptProv;dwFlags:DWord):boolean;stdcall;

function CryptGenRandom(phProv:TCryptProv;dwLen:DWord;pbBuffer:pointer):BOOL;stdcall;

function CryptStringToBinary(pszString:PChar;cchString:DWord;dwFlags:DWord;pbBinary:pointer;var pcbBinary:DWord;
	var pdwSkip:DWord;var pdwFlags:DWord):boolean;stdcall;

function CryptBinaryToString(pbBinary:pointer;cbBinary:DWord;dwFlags:DWord;pszString:PChar;var pcchString:DWord)
	:boolean;stdcall;

function CryptStringToBinaryA(pszString:PChar;cchString:DWord;dwFlags:DWord;pbBinary:pointer;var pcbBinary:DWord;
	var pdwSkip:DWord;var pdwFlags:DWord):boolean;stdcall;

function CryptBinaryToStringA(pbBinary:pointer;cbBinary:DWord;dwFlags:DWord;pszString:PChar;var pcchString:DWord)
	:boolean;stdcall;

function CryptStringToBinaryW(pszString:PWideChar;cchString:DWord;dwFlags:DWord;pbBinary:pointer;var pcbBinary:DWord;
	var pdwSkip:DWord;var pdwFlags:DWord):boolean;stdcall;

function CryptBinaryToStringW(pbBinary:pointer;cbBinary:DWord;dwFlags:DWord;pszString:PWideChar;var pcchString:DWord)
	:boolean;stdcall;

function CryptEncrypt(hKey:TCryptKey;hHash:TCryptHash;Final:BOOL;dwFlags:DWord;pbData:pointer;var pdwDataLen:DWord;
	dwBufLen:DWord):BOOL;stdcall;

function CryptDecrypt(hKey:TCryptKey;hHash:TCryptHash;Final:BOOL;dwFlags:DWord;pbData:pointer;var pdwDataLen:DWord)
	:BOOL;stdcall;

function CryptDeriveKey(hProv:TCryptProv;Algid:TAlgID;hBaseData:TCryptHash;dwFlags:DWord;var phKey:TCryptKey)
	:BOOL;stdcall;

implementation

function CryptAcquireContext;external advapi name 'CryptAcquireContextA';
function CryptAcquireContextA;external advapi name 'CryptAcquireContextA';
function CryptAcquireContextW;external advapi name 'CryptAcquireContextW';
function CryptCreateHash;external advapi name 'CryptCreateHash';
function CryptHashData;external advapi name 'CryptHashData';
function CryptGetHashParam;external advapi name 'CryptGetHashParam';
function CryptDestroyHash;external advapi name 'CryptDestroyHash';
function CryptReleaseContext;external advapi name 'CryptReleaseContext';

function CryptGenRandom;external advapi name 'CryptGenRandom';

function CryptStringToBinary;external crypt32 name 'CryptStringToBinaryA';
function CryptBinaryToString;external crypt32 name 'CryptBinaryToStringA';
function CryptStringToBinaryA;external crypt32 name 'CryptStringToBinaryA';
function CryptBinaryToStringA;external crypt32 name 'CryptBinaryToStringA';
function CryptStringToBinaryW;external crypt32 name 'CryptStringToBinaryW';
function CryptBinaryToStringW;external crypt32 name 'CryptBinaryToStringW';

function CryptEncrypt;external advapi name 'CryptEncrypt';
function CryptDecrypt;external advapi name 'CryptDecrypt';
function CryptDeriveKey;external advapi name 'CryptDeriveKey';

end.
