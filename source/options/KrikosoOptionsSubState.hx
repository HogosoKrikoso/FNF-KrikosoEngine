package options;

import objects.Note;
import objects.StrumNote;
import objects.Alphabet;

class KrikosoOptionsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Krikoso Engine';
		rpcTitle = 'Krikoso Engine Menu'; //for Discord Rich Presence

		#if android
		var option:Option = new Option('Storage Folder:',
			"What Folder should the engine use?",
			'storageFolder',
			'string',
			['Krikoso Engine', 'Psych Engine', 'NovaFlare Engine', 'Data', 'Media', 'Obb']);
		addOption(option);
		#end
		
		var option:Option = new Option('Score Text Separator:',
			"What separator should use the Score Text?",
			'separator',
			'string',
			['Double Slash', 'Minus Symbol', 'Pipe', 'Circle', 'Virgulilla']);
		addOption(option);

		var option:Option = new Option('Combo on Stage',
			"If checked, Ratings and Combo will show on Stage instead of UI.",
			'scoreOnWorld',
			'bool');
		addOption(option);
		
		var option:Option = new Option('Force Skip Countdown',
			"If checked, It will force the game to skip the countdown.",
			'forceSkipCountdown',
			'bool');
		addOption(option);

		var option:Option = new Option('Chart Randomizing',
			"If checked, It will randomize the direction of the notes.",
			'randomNotesDirection',
			'bool');
		addOption(option);

		super();
	}
}
