{ ******************************************************* }
{ }
{ Borland Delphi Run-time Library }
{ Empty Volume Cache Interfaces }
{ }
{ Copyright (c) 1985-2000, Microsoft Corporation }
{ }
{ Translator: Denis Blondeau }
{ Last modification: 19 Apr 01 }
{ }
{ ******************************************************* }

unit EmptyVC;

{$ALIGN ON}

interface

uses
	Windows;

const
	// String constants for Interface IDs
	SID_IEmptyVolumeCache='{8FCE5227-04DA-11D1-A004-00805F8ABE06}';
	SID_IEmptyVolumeCache2='{02B7E3BA-4DB3-11D2-B2D9-00C04F8EEC8C}';
	SID_IEmptyVolumeCacheCallBack='{6E793361-73C6-11D0-8469-00AA00442901}';


	// IEmptyVolumeCache Flags.

	EVCF_HASSETTINGS=$0001;
	EVCF_ENABLEBYDEFAULT=$0002;
	EVCF_REMOVEFROMLIST=$0004;
	EVCF_ENABLEBYDEFAULT_AUTO=$0008;
	EVCF_DONTSHOWIFZERO=$0010;
	EVCF_SETTINGSMODE=$0020;
	EVCF_OUTOFDISKSPACE=$0040;


	// IEmptyVolumeCacheCallBack Flags.

	EVCCBF_LASTNOTIFICATION=$0001;

type

	{ IEmptyVolumeCacheCallBack }

	IEmptyVolumeCacheCallBack=interface(IUnknown)
		[SID_IEmptyVolumeCacheCallBack]
		function ScanProgress(dwlSpaceUsed:Int64;dwFlags:DWORD;pcwszStatus:LPCWSTR):HResult;stdcall;
		function PurgeProgress(dwlSpaceFreed,dwlSpaceToFree:Int64;dwFlags:DWORD;pcwszStatus:LPCWSTR):HResult;stdcall;
	end;

	{ IEmptyVolumeCache }

	IEmptyVolumeCache=interface(IUnknown)
		[SID_IEmptyVolumeCache]
		function Initialize(hkRegKey:HKEY;pcwszVolume:LPCWSTR;var ppwszDisplayName,ppwszDescription:LPWSTR;
			var pdwFlags:DWORD):HResult;stdcall;
		function GetSpaceUsed(var pdwlSpaceUsed:Int64;const picb:IEmptyVolumeCacheCallBack):HResult;stdcall;
		function Purge(dwlSpaceToFree:Int64;const picb:IEmptyVolumeCacheCallBack):HResult;stdcall;
		function ShowProperties(hwnd:hwnd):HResult;stdcall;
		function Deactivate(var pdwFlags:DWORD):HResult;stdcall;
	end;

	{ IEmptyVolumeCache2 }

	IEmptyVolumeCache2=interface(IEmptyVolumeCache)
		[SID_IEmptyVolumeCache2]
		function InitializeEx(hkRegKey:HKEY;pcwszVolume,pcwszKeyName:LPCWSTR;
			var ppwszDisplayName,ppwszDescription,ppwszBtnText:LPWSTR;var pdwFlags:DWORD):HResult;stdcall;
	end;

implementation

end.
