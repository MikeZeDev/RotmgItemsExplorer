package utils {
import flash.text.*;

public class XMLCodeHinting {
    // defaults if none are given


    private static var textColor:TextFormat = new TextFormat('Courier New', 14, 0x000000);
    private static var commentColor:TextFormat = new TextFormat(null, null, 0x999999);
    private static var tagColor:TextFormat = new TextFormat(null, null, 0xCC0000);
    private static var cdataColor:TextFormat = new TextFormat(null, null, 0x00CC00);
    private static var attColor:TextFormat = new TextFormat(null, null, 0x0000CC);
    private static var tagExp:RegExp = /(<[^<!]).*?>/gs;
    private static var cdataStartExp:RegExp = /<!\[CDATA\[/g;
    private static var cdataEndExp:RegExp = /\]\]>/g;
    private static var quoteExp:RegExp = /[a-z0-9_]*=".*?"|[a-z0-9_]*='.*?'/gi;
    private static var mCommentExp:RegExp = /<!--.*?(-->)/gs;

    public static function set defaultFormat(val:*):void {
        if (val is TextFormat) {
            textColor = val as TextFormat;
            return;
        }
        textColor.color = val;
    }

    public static function get defaultFormat():TextFormat {
        return textColor;
    }

    public static function set commentFormat(val:*):void {
        if (val is TextFormat) {
            commentColor = val as TextFormat;
            return
        }
        commentColor.color = val;
    }

    public static function get commentFormat():TextFormat {
        return commentColor;
    }

    public static function set tagFormat(val:*):void {
        if (val is TextFormat) {
            tagColor = val as TextFormat;
            return;
        }
        tagColor.color = val;
    }

    public static function get tagFormat():TextFormat {
        return tagColor;
    }


    public static function set cdataFormat(val:*):void {
        if (val is TextFormat) {
            cdataColor = val as TextFormat;
            return;
        }
        cdataColor.color = val;
    }

    public static function get cdataFormat():TextFormat {
        return cdataColor;
    }

    public static function set attributeFormat(val:*):void {
        if (val is TextFormat) {
            attColor = val as TextFormat;
            return;
        }
        attColor.color = val;
    }

    public static function get attributeFormat():TextFormat {
        return attColor;
    }

    public static function colorize(_txt:TextField):void {
        _txt.setTextFormat(textColor);
        var txt:String = _txt.text;
        var match:Object;
        match = tagExp.exec(txt);
        while (match != null) {
            _txt.setTextFormat(tagColor, match.index, match.index + match[0].length);
            match = tagExp.exec(txt);
        }
        match = cdataStartExp.exec(txt);
        while (match != null) {
            _txt.setTextFormat(cdataColor, match.index, match.index + match[0].length);
            match = cdataStartExp.exec(txt);
        }

        match = cdataEndExp.exec(txt);
        while (match != null) {
            _txt.setTextFormat(cdataColor, match.index, match.index + match[0].length);
            match = cdataEndExp.exec(txt);
        }
        match = quoteExp.exec(txt);
        while (match != null) {
            _txt.setTextFormat(attColor, match.index, match.index + match[0].length);
            match = quoteExp.exec(txt);
        }
        match = mCommentExp.exec(txt);
        while (match != null) {
            _txt.setTextFormat(commentColor, match.index, match.index + match[0].length);
            match = mCommentExp.exec(txt);
        }
    }
}
}