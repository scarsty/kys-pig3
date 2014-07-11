unit kys_Lock;

interface

uses
  Windows, SysUtils;

type
  PTOKEN_USER = ^TOKEN_USER;

  _TOKEN_USER = record
    User: SID_AND_ATTRIBUTES;
  end;
  TOKEN_USER = _TOKEN_USER;

  SE_OBJECT_TYPE = (
    SE_UNKNOWN_OBJECT_TYPE = 0,
    SE_FILE_OBJECT,
    SE_SERVICE,
    SE_PRINTER,
    SE_REGISTRY_KEY,
    SE_LMSHARE,
    SE_KERNEL_OBJECT,
    SE_WINDOW_OBJECT,
    SE_DS_OBJECT,
    SE_DS_OBJECT_ALL,
    SE_PROVIDER_DEFINED_OBJECT,
    SE_WMIGUID_OBJECT,
    SE_REGISTRY_WOW64_32KEY
    );




const

  SECURITY_NULL_SID_AUTHORITY: _SID_IDENTIFIER_AUTHORITY = (Value: (0, 0, 0, 0, 0, 0));
  SECURITY_WORLD_SID_AUTHORITY: _SID_IDENTIFIER_AUTHORITY = (Value: (0, 0, 0, 0, 0, 1));
  SECURITY_LOCAL_SID_AUTHORITY: _SID_IDENTIFIER_AUTHORITY = (Value: (0, 0, 0, 0, 0, 2));
  SECURITY_CREATOR_SID_AUTHORITY: _SID_IDENTIFIER_AUTHORITY = (Value: (0, 0, 0, 0, 0, 3));
  SECURITY_NON_UNIQUE_AUTHORITY: _SID_IDENTIFIER_AUTHORITY = (Value: (0, 0, 0, 0, 0, 4));
  SECURITY_NT_AUTHORITY: _SID_IDENTIFIER_AUTHORITY = (Value: (0, 0, 0, 0, 0, 5));

function SetSecurityInfo(handle: THANDLE; ObjectType: SE_OBJECT_TYPE; SecurityInfo: SECURITY_INFORMATION;
  psidOwner: PSID; psidGroup: PSID; pDacl: PACL; pSacl: PACL): longword;
  stdcall; external advapi32 Name 'SetSecurityInfo';


function AllocateAndInitializeSid(const pIdentifierAuthority: PSIDIdentifierAuthority; (*Delphi 2007当中此参数的声明有问题*)
  nSubAuthorityCount: byte; nSubAuthority0, nSubAuthority1: DWORD;
  nSubAuthority2, nSubAuthority3, nSubAuthority4: DWORD; nSubAuthority5, nSubAuthority6, nSubAuthority7: DWORD;
  var pSid: Pointer): BOOL; stdcall; external advapi32 Name 'AllocateAndInitializeSid';


//下列API的第一个参数声明不应该使用var,所以重新声明
function InitializeAcl(pAcl: PACL; nAclLength, dwAclRevision: DWORD): BOOL; stdcall;
  external advapi32 Name 'InitializeAcl';
function AddAccessDeniedAce(pAcl: PACL; dwAceRevision: DWORD; AccessMask: DWORD; pSid: PSID): BOOL;
  stdcall; external advapi32 Name 'AddAccessDeniedAce';
function AddAccessAllowedAce(pAcl: PACL; dwAceRevision: DWORD; AccessMask: DWORD; pSid: PSID): BOOL;
  stdcall; external advapi32 Name 'AddAccessAllowedAce';

function Lockmem: boolean;

implementation


function LockMem: boolean;
var
  hProcess: THandle;
  sia: SID_IDENTIFIER_AUTHORITY;
  _pSid: PSID;
  bSus: longbool;
  hToken: THandle;
  dwReturnLength: longword;
  TokenInformation: Pointer;
  dw: longword;
  pTokenUser: PTOKEN_USER;
  Buf: array[0..$200 - 1] of byte;
  _pAcl: PACL;
begin
  hProcess := GetCurrentProcess();
  sia := SECURITY_WORLD_SID_AUTHORITY;
  bSus := False;
  if (AllocateAndInitializeSid(@sia, 1, 0, 0, 0, 0, 0, 0, 0, 0, _pSid)) then
  begin
    if (OpenProcessToken(hProcess, TOKEN_QUERY, hToken)) then
    begin
      GetTokenInformation(hToken, TokenUser, nil, 0, dwReturnLength);
      if (dwReturnLength <= $400) then
      begin
        TokenInformation := Pointer(LocalAlloc(LPTR, $400)); //这里就引用SDK的函数不引用CRT的了
        if (GetTokenInformation(hToken, TokenUser, TokenInformation, $400, dw)) then
        begin
          pTokenUser := PTOKEN_USER(TokenInformation);
          _pAcl := PACL(@Buf[0]);
          if ((InitializeAcl(_pAcl, 1024, 2 (*ACL_REVISION*))) and
            (AddAccessDeniedAce(_pAcl, 2 (*ACL_REVISION*), $000000FA, _pSid)) and
            (AddAccessAllowedAce(_pAcl, 2 (*ACL_REVISION*), $00100701, pTokenUser^.User.Sid)) and
            (SetSecurityInfo(hProcess, SE_KERNEL_OBJECT, DACL_SECURITY_INFORMATION or
            $80000000 (*PROTECTED_DACL_SECURITY_INFORMATION*), nil, nil, _pAcl, nil) = 0)) then
          begin
            bSus := True;
          end;
        end;

      end;

    end;
  end;

  //Cleanup
  if (hProcess <> 0) then
  begin
    CloseHandle(hProcess);
  end;

  if (_pSid <> nil) then
  begin
    FreeSid(_pSid);
  end;
  Result := bSus;
end;


end.
