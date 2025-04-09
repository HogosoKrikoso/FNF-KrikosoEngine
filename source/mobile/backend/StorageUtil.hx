/*
 * Copyright (C) 2025 Mobile Porting Team
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

package mobile.backend;

import lime.system.System as LimeSystem;
import haxe.io.Path;

/**
 * A storage class for mobile.
 * @author Karim Akra and Lily Ross (mcagabe19)
 */
class StorageUtil
{
	#if sys

	public static final rootDir:String = LimeSystem.applicationStorageDirectory;
		
	public static function getStorageDirectory():String {
		var path:String = '';
		#if android
			if (!FileSystem.exists(rootDir + 'storageFolder.txt'))
			        File.saveContent(rootDir + 'storageFolder.txt', ClientPrefs.data.storageFolder);
		        var storageFolder:String = File.getContent(rootDir + 'storageFolder.txt');
	        	path = getUnforcedPath(storageFolder);
		#elseif ios
			path = lime.system.System.documentsDirectory;
		#else
			path = Sys.getCwd();
		#end
		return path;
	}
	
	public static function getForcedPath(folderType:String):String {
		var path:String = '';
		var externalStorageDir:String = '/storage/emulated/0';
		var localPackage:String = 'com.hogoso.krikosoengine';
		switch(folderType) {
			case 'NovaFlare Engine':
					path = externalStorageDir + '/.NF Engine';
			case 'Psych Engine':
					path = externalStorageDir + '/.PsychEngine';
			case 'Krikoso Engine': 
				path = externalStorageDir + '/.KrikosoEngine';
			case 'Psych Online': 
				path = externalStorageDir + '/.PsychOnline';
			case 'Data': 
				path = externalStorageDir + '/Android/data/' + localPackage + '/files';
			case 'Obb':
			        path = externalStorageDir + '/Android/obb/' + localPackage;
			case 'Media':
			        path = externalStorageDir + '/Android/media/' + localPackage;
		}
		return path;
	}
					
        public static function getUnforcedPath(folderType:String):String {
		var path:String = '';
		switch(folderType) {
			case 'NovaFlare Engine':
				path = haxe.io.Path.addTrailingSlash(AndroidEnvironment.getExternalStorageDirectory() + '/.NF Engine');
			case 'Psych Engine':
				path = haxe.io.Path.addTrailingSlash(AndroidEnvironment.getExternalStorageDirectory() + '/.PsychEngine');
			case 'Krikoso Engine': 
				path = haxe.io.Path.addTrailingSlash(AndroidEnvironment.getExternalStorageDirectory() + '/.KrikosoEngine');
			case 'Psych Online': 
				path = haxe.io.Path.addTrailingSlash(AndroidEnvironment.getExternalStorageDirectory() + '/.PsychOnline');
			case 'Data': 
				path = haxe.io.Path.addTrailingSlash(AndroidContext.getExternalFilesDir());
			case 'Obb':
			        path = haxe.io.Path.addTrailingSlash(AndroidContext.getObbDir());
			case 'Media':
			        path = haxe.io.Path.addTrailingSlash(AndroidEnvironment.getExternalStorageDirectory() + '/Android/media/' + lime.app.Application.current.meta.get('packageName'));
		}
		return path;
	}
	
	public static function saveContent(fileName:String, fileData:String, ?alert:Bool = true):Void
	{
		try
		{
			if (!FileSystem.exists('saves'))
				FileSystem.createDirectory('saves');

			File.saveContent('saves/$fileName', fileData);
			if (alert)
				CoolUtil.showPopUp('$fileName has been saved.', "Success!");
		}
		catch (e:Dynamic)
			if (alert)
				CoolUtil.showPopUp('$fileName couldn\'t be saved.\n(${e.message})', "Error!")
			else
				trace('$fileName couldn\'t be saved. (${e.message})');
	}

	#if android
	public static function requestPermissions():Void
	{
		if (AndroidVersion.SDK_INT >= AndroidVersionCode.TIRAMISU)
			AndroidPermissions.requestPermissions(['READ_MEDIA_IMAGES', 'READ_MEDIA_VIDEO', 'READ_MEDIA_AUDIO', 'READ_MEDIA_VISUAL_USER_SELECTED']);
		else
			AndroidPermissions.requestPermissions(['READ_EXTERNAL_STORAGE', 'WRITE_EXTERNAL_STORAGE']);

		if (!AndroidEnvironment.isExternalStorageManager())
			AndroidSettings.requestSetting('MANAGE_APP_ALL_FILES_ACCESS_PERMISSION');

		if ((AndroidVersion.SDK_INT >= AndroidVersionCode.TIRAMISU
			&& !AndroidPermissions.getGrantedPermissions().contains('android.permission.READ_MEDIA_IMAGES'))
			|| (AndroidVersion.SDK_INT < AndroidVersionCode.TIRAMISU
				&& !AndroidPermissions.getGrantedPermissions().contains('android.permission.READ_EXTERNAL_STORAGE')))
			CoolUtil.showPopUp('If you accepted the permissions you are all good!' + '\nIf you didn\'t then expect a crash' + '\nPress OK to see what happens',
				'Notice!');

		try
		{
			if (!FileSystem.exists(StorageUtil.getStorageDirectory()))
				FileSystem.createDirectory(StorageUtil.getStorageDirectory());
		}
		catch (e:Dynamic)
		{
			CoolUtil.showPopUp('Please create directory to\n' + StorageUtil.getStorageDirectory() + '\nPress OK to close the game', 'Error!');
			lime.system.System.exit(1);
		}
	}
	#end
	#end
			}
		
