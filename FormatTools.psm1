function Format-Banner
{
    [CmdletBinding()]
    param (
        [Parameter(ValueFromRemainingArguments,ValueFromPipeline=$true,position=0,mandatory=$true)]
        [string[]]$strings,
        [switch]$asString ,
        [char]$marker = "#"
        )
    BEGIN
    {
        $bit = @( 128, 64, 32, 16, 8, 4, 2, 1 )
        $chars = @(
                @( 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ),   # ' '
                @( 0x38, 0x38, 0x38, 0x10, 0x00, 0x38, 0x38 ),   # '!'
                @( 0x24, 0x24, 0x24, 0x00, 0x00, 0x00, 0x00 ),   # '"' UNV
                @( 0x28, 0x28, 0xFE, 0x28, 0xFE, 0x28, 0x28 ),   # '#'
                @( 0x7C, 0x92, 0x90, 0x7C, 0x12, 0x92, 0x7C ),   # '$'
                @( 0xE2, 0xA4, 0xE8, 0x10, 0x2E, 0x4A, 0x8E ),   # '%'
                @( 0x30, 0x48, 0x30, 0x70, 0x8A, 0x84, 0x72 ),   # '&'
                @( 0x38, 0x38, 0x10, 0x20, 0x00, 0x00, 0x00 ),   # '''
                @( 0x18, 0x20, 0x40, 0x40, 0x40, 0x20, 0x18 ),   # '('
                @( 0x30, 0x08, 0x04, 0x04, 0x04, 0x08, 0x30 ),   # ')'
                @( 0x00, 0x44, 0x28, 0xFE, 0x28, 0x44, 0x00 ),   # '*'
                @( 0x00, 0x10, 0x10, 0x7C, 0x10, 0x10, 0x00 ),   # '+'
                @( 0x00, 0x00, 0x00, 0x38, 0x38, 0x10, 0x20 ),   # ','
                @( 0x00, 0x00, 0x00, 0x7C, 0x00, 0x00, 0x00 ),   # '-'
                @( 0x00, 0x00, 0x00, 0x00, 0x38, 0x38, 0x38 ),   # '.'
                @( 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 ),   # '/'
                @( 0x38, 0x44, 0x82, 0x82, 0x82, 0x44, 0x38 ),   # '0'
                @( 0x10, 0x30, 0x50, 0x10, 0x10, 0x10, 0x7C ),   # '1'
                @( 0x7C, 0x82, 0x02, 0x7C, 0x80, 0x80, 0xFE ),   # '2'
                @( 0x7C, 0x82, 0x02, 0x7C, 0x02, 0x82, 0x7C ),   # '3'
                @( 0x80, 0x84, 0x84, 0x84, 0xFE, 0x04, 0x04 ),   # '4'
                @( 0xFE, 0x80, 0x80, 0xFC, 0x02, 0x82, 0x7C ),   # '5'
                @( 0x7C, 0x82, 0x80, 0xFC, 0x82, 0x82, 0x7C ),   # '6'
                @( 0xFC, 0x84, 0x08, 0x10, 0x20, 0x20, 0x20 ),   # '7'
                @( 0x7C, 0x82, 0x82, 0x7C, 0x82, 0x82, 0x7C ),   # '8'
                @( 0x7C, 0x82, 0x82, 0x7E, 0x02, 0x82, 0x7C ),   # '9'
                @( 0x10, 0x38, 0x10, 0x00, 0x10, 0x38, 0x10 ),   # ':'
                @( 0x38, 0x38, 0x00, 0x38, 0x38, 0x10, 0x20 ),   # ';'
                @( 0x08, 0x10, 0x20, 0x40, 0x20, 0x10, 0x08 ),   # '<'
                @( 0x00, 0x00, 0xFE, 0x00, 0xFE, 0x00, 0x00 ),   # '=' UNV.
                @( 0x20, 0x10, 0x08, 0x04, 0x08, 0x10, 0x20 ),   # '>'
                @( 0x7C, 0x82, 0x02, 0x1C, 0x10, 0x00, 0x10 ),   # '?'
                @( 0x7C, 0x82, 0xBA, 0xBA, 0xBC, 0x80, 0x7C ),   # '@'
                @( 0x10, 0x28, 0x44, 0x82, 0xFE, 0x82, 0x82 ),   # 'A'
                @( 0xFC, 0x82, 0x82, 0xFC, 0x82, 0x82, 0xFC ),   # 'B'
                @( 0x7C, 0x82, 0x80, 0x80, 0x80, 0x82, 0x7C ),   # 'C'
                @( 0xFC, 0x82, 0x82, 0x82, 0x82, 0x82, 0xFC ),   # 'D'
                @( 0xFE, 0x80, 0x80, 0xF8, 0x80, 0x80, 0xFE ),   # 'E'
                @( 0xFE, 0x80, 0x80, 0xF8, 0x80, 0x80, 0x80 ),   # 'F'
                @( 0x7C, 0x82, 0x80, 0x9E, 0x82, 0x82, 0x7C ),   # 'G'
                @( 0x82, 0x82, 0x82, 0xFE, 0x82, 0x82, 0x82 ),   # 'H'
                @( 0x38, 0x10, 0x10, 0x10, 0x10, 0x10, 0x38 ),   # 'I'
                @( 0x02, 0x02, 0x02, 0x02, 0x82, 0x82, 0x7C ),   # 'J'
                @( 0x84, 0x88, 0x90, 0xE0, 0x90, 0x88, 0x84 ),   # 'K'
                @( 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0xFE ),   # 'L'
                @( 0x82, 0xC6, 0xAA, 0x92, 0x82, 0x82, 0x82 ),   # 'M'
                @( 0x82, 0xC2, 0xA2, 0x92, 0x8A, 0x86, 0x82 ),   # 'N'
                @( 0xFE, 0x82, 0x82, 0x82, 0x82, 0x82, 0xFE ),   # 'O'
                @( 0xFC, 0x82, 0x82, 0xFC, 0x80, 0x80, 0x80 ),   # 'P'
                @( 0x7C, 0x82, 0x82, 0x82, 0x8A, 0x84, 0x7A ),   # 'Q'
                @( 0xFC, 0x82, 0x82, 0xFC, 0x88, 0x84, 0x82 ),   # 'R'
                @( 0x7C, 0x82, 0x80, 0x7C, 0x02, 0x82, 0x7C ),   # 'S'
                @( 0xFE, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10 ),   # 'T'
                @( 0x82, 0x82, 0x82, 0x82, 0x82, 0x82, 0x7C ),   # 'U'
                @( 0x82, 0x82, 0x82, 0x82, 0x44, 0x28, 0x10 ),   # 'V'
                @( 0x82, 0x92, 0x92, 0x92, 0x92, 0x92, 0x6C ),   # 'W'
                @( 0x82, 0x44, 0x28, 0x10, 0x28, 0x44, 0x82 ),   # 'X'
                @( 0x82, 0x44, 0x28, 0x10, 0x10, 0x10, 0x10 ),   # 'Y'
                @( 0xFE, 0x04, 0x08, 0x10, 0x20, 0x40, 0xFE ),   # 'Z'
                @( 0x7C, 0x40, 0x40, 0x40, 0x40, 0x40, 0x7C ),   # '['
                @( 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02 ),   # '\'
                @( 0x7C, 0x04, 0x04, 0x04, 0x04, 0x04, 0x7C ),   # ']'
                @( 0x10, 0x28, 0x44, 0x00, 0x00, 0x00, 0x00 ),   # '^'
                @( 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFE ),   # '_'
                @( 0x00, 0x38, 0x38, 0x10, 0x08, 0x00, 0x00 ),   # '`'
                @( 0x00, 0x18, 0x24, 0x42, 0x7E, 0x42, 0x42 ),   # 'a'
                @( 0x00, 0x7C, 0x42, 0x7C, 0x42, 0x42, 0x7C ),   # 'b'
                @( 0x00, 0x3C, 0x42, 0x40, 0x40, 0x42, 0x3C ),   # 'c'
                @( 0x00, 0x7C, 0x42, 0x42, 0x42, 0x42, 0x7C ),   # 'd'
                @( 0x00, 0x7E, 0x40, 0x7C, 0x40, 0x40, 0x7E ),   # 'e'
                @( 0x00, 0x7E, 0x40, 0x7C, 0x40, 0x40, 0x40 ),   # 'f'
                @( 0x00, 0x3C, 0x42, 0x40, 0x4E, 0x42, 0x3C ),   # 'g'
                @( 0x00, 0x42, 0x42, 0x7E, 0x42, 0x42, 0x42 ),   # 'h'
                @( 0x00, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08 ),   # 'i'
                @( 0x00, 0x02, 0x02, 0x02, 0x02, 0x42, 0x3C ),   # 'j'
                @( 0x00, 0x42, 0x44, 0x78, 0x48, 0x44, 0x42 ),   # 'k'
                @( 0x00, 0x40, 0x40, 0x40, 0x40, 0x40, 0x7E ),   # 'l'
                @( 0x00, 0x42, 0x66, 0x5A, 0x42, 0x42, 0x42 ),   # 'm'
                @( 0x00, 0x42, 0x62, 0x52, 0x4A, 0x46, 0x42 ),   # 'n'
                @( 0x00, 0x3C, 0x42, 0x42, 0x42, 0x42, 0x3C ),   # 'o'
                @( 0x00, 0x7C, 0x42, 0x42, 0x7C, 0x40, 0x40 ),   # 'p'
                @( 0x00, 0x3C, 0x42, 0x42, 0x4A, 0x44, 0x3A ),   # 'q'
                @( 0x00, 0x7C, 0x42, 0x42, 0x7C, 0x44, 0x42 ),   # 'r'
                @( 0x00, 0x3C, 0x40, 0x3C, 0x02, 0x42, 0x3C ),   # 's'
                @( 0x00, 0x3E, 0x08, 0x08, 0x08, 0x08, 0x08 ),   # 't'
                @( 0x00, 0x42, 0x42, 0x42, 0x42, 0x42, 0x3C ),   # 'u'
                @( 0x00, 0x42, 0x42, 0x42, 0x42, 0x24, 0x18 ),   # 'v'
                @( 0x00, 0x42, 0x42, 0x42, 0x5A, 0x66, 0x42 ),   # 'w'
                @( 0x00, 0x42, 0x24, 0x18, 0x18, 0x24, 0x42 ),   # 'x'
                @( 0x00, 0x22, 0x14, 0x08, 0x08, 0x08, 0x08 ),   # 'y'
                @( 0x00, 0x7E, 0x04, 0x08, 0x10, 0x20, 0x7E ),   # 'z'
                @( 0x38, 0x40, 0x40, 0xC0, 0x40, 0x40, 0x38 ),   # '{'
                @( 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10 ),   # '|'
                @( 0x38, 0x04, 0x04, 0x06, 0x04, 0x04, 0x38 ),   # '}'
                @( 0x60, 0x92, 0x0C, 0x00, 0x00, 0x00, 0x00 )    # '~'
        );
        $o = new-object -TypeName psobject
        $o | add-member -MemberType NoteProperty -Name OriginalStrings -Value @()
        $o.psobject.typenames.Insert(0,"Banner")
    }
    PROCESS
    {
        $o.OriginalStrings += $strings
        $output = ""
        $length = "$strings".length
        $width = [math]::floor(($host.ui.rawui.buffersize.width-1)/8)
        # check and bail if a string is too long
        foreach ( $substring in $strings)
        {
            if ($substring.length -gt $width)
            {
                throw "strings must be less than $width characters"
            }
        }

        foreach($substring in $strings)
        {
            for($r = 0; $r -lt 7; $r++)
            {
                foreach($c in $substring.ToCharArray())
                {
                    $bitmap = 0
                    if ( ($c -ge " ") -and ($c -le [char]"~"))
                    {
                        $offset = ([int]$c) - 32
                        $bitmap = $chars[$offset][$r]
                    }
                    for($c=0;$c -lt 8;$c++)
                    {
                        if ( $bitmap -band $bit[$c] ) { $output += $marker } else { $output += " " }
                    }
                }
                $output += "`n"
            }
        }
        #$output
        $sb = $executioncontext.invokecommand.NewScriptBlock("'$output'")
        $o | add-member -force -MemberType ScriptMethod -Name ToString -Value $sb
        if ( $asString )
        {
            $o.ToString()
        }
        else
        {
            $o
        }
    }
}

function New-TableFormat
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]$object,
        [Parameter(Mandatory=$true,Position=0)][object[]]$property,
        [Parameter(Mandatory=$false,Position=1)][string]$group,
        [switch]$auto, $name,
        [switch]$force,
        [switch]$StandAlone
        )
    Begin
    {
        $TypeCollection = @{}
    }
    Process
    {
        if ( ! $TypeCollection.ContainsKey($object.gettype().Fullname))
        {
            $TypeCollection[$object.gettype().FullName] = 1
        }
    }
    End
    {
        $SelectionSet = $null
        if ( $TypeCollection.Keys.Count -gt 1 )
        {
            $SelectionSetName = ($typeCollection.keys |sort-object| foreach-object { $_.split(".")[-1] }) -join "_"
            $SelectionSet = "<SelectionSets>",
                " <SelectionSet>",
                "  <Name>${SelectionSetName}</Name>",
                "  <Types>"
            $SelectionSet += $TypeCollection.Keys | foreach-object{ "    <TypeName>$_</TypeName>" }
            $SelectionSet += "  </Types>", " </SelectionSet>", "</SelectionSets>"

        }
        if ( $StandAlone )
        {
            "<Configuration>"
        }
        if ( $SelectionSet )
        {
            $SelectionSet
        }

        if ( $StandAlone )
        {
            "   <ViewDefinitions>"
        }
        if ( $name )
        {
            $TN = $name
            $TypeNameSelector = "<TypeName>${TN}</TypeName>`n"
        }
        elseif ( $object -and ($SelectionSet -eq $null) )
        {
            if ( $object -is "PSObject")
            {
                $TN = $object.psobject.typenames[0]
            }
            else
            {
                $TN = $object.gettype().fullname
            }
            $TypeNameSelector = "<TypeName>${TN}</TypeName>`n"
        }
        elseif ( $SelectionSet -ne $null )
        {
            $TN = $SelectionSetName
            $TypeNameSelector = "<SelectionSetName>${SelectionSetName}</SelectionSetName>"
        }
        # skip this check for now, because we added support for hashtables,
        # we need to just keep going
        #foreach($p in $property)
        #{
        #    if(! $object.psobject.members.item($p) -and ! $force)
        #    {
        #        $property = $property | ?{ $_ -notmatch $p }
        #        write-host -for red "$p does not exist, skipping"
        #    }
        #}
        $NAME = $TN.split(".")[-1]
        $sb = new-object -TypeName System.Text.StringBuilder
        [void]$sb.AppendLine("   <View>")
        [void]$sb.AppendLine("    <Name>${Name}Table</Name>")
        [void]$sb.AppendLine("    <ViewSelectedBy>")
        [void]$sb.AppendLine("     ${TypeNameSelector}")
        [void]$sb.AppendLine("    </ViewSelectedBy>")
        if ( $group )
        {
            [void]$sb.AppendLine("    <GroupBy>")
            [void]$sb.AppendLine("      <PropertyName>$group</PropertyName>")
            [void]$sb.AppendLine("      <Label>$group</Label>")
            [void]$sb.AppendLine("    </GroupBy>")
        }
        [void]$sb.AppendLine("    <TableControl>")
        if ( $auto )
        {
            [void]$sb.AppendLine("     <AutoSize />")
        }
        [void]$sb.AppendLine("     <TableHeaders>")
        ###
        ### HEADER
        ###
        foreach($p in $property)
        {
            if ( $p -is "string" )
            {
                [void]$sb.AppendLine("      <TableColumnHeader><Label>${p}</Label></TableColumnHeader>")
            }
            elseif ( $p -is "scriptblock" )
            {
                [void]$sb.AppendLine("      <TableColumnHeader>")
                [void]$sb.AppendLine("        <Label>" + $p.ToString() + "</Label>")
                [void]$sb.AppendLine("      </TableColumnHeader>")
            }
            elseif ( $p -is "hashtable" )
            {
                $Label = $p.keys | ?{$_ -match "^L" }
                if ( ! $Label )
                {
                    throw "need Name or Label Key"
                }
                [void]$sb.AppendLine("      <TableColumnHeader>")
                [void]$sb.AppendLine("        <Label>" + $p.$label + "</Label>")
                $Width = $p.Keys |?{$_ -match "^W"}
                if ( $Width )
                {
                    [void]$sb.AppendLine("        <Width>" + $p.$Width + "</Width>")
                }
                $Align = $p.Keys |?{$_ -match "^A"}
                if ( $Align )
                {
                    [void]$sb.AppendLine("        <Alignment>" + $p.$align + "</Alignment>")
                }
                [void]$sb.AppendLine("      </TableColumnHeader>")
                # write-host -for red ("skipping " + $p.Name + " for now")
            }
            else {
                throw "unknown element '$p'"
            }
        }
        [void]$sb.AppendLine("     </TableHeaders>")
        ###
        ### ROWS
        ###
        [void]$sb.AppendLine("     <TableRowEntries>")
        [void]$sb.AppendLine("      <TableRowEntry>")
        [void]$sb.AppendLine("       <TableColumnItems>")
        foreach($p in $property)
        {
            [void]$sb.Append("        <TableColumnItem>")
            if ( $p -is "string" )
            {
                [void]$sb.Append("<PropertyName>${p}</PropertyName>")
            }
            elseif ( $p -is "Scriptblock" )
            {
                [void]$sb.Append("<ScriptBlock>" + $p.tostring() + "</ScriptBlock>")
            }
            elseif ( $p -is "hashtable" )
            {
                $Name = $p.Keys | ?{$_ -match "^N" }
                if ( $Name )
                {
                    [void]$sb.Append("<PropertyName>" + $p.$Name + "</PropertyName>")
                }
                $Format = $p.Keys |?{$_ -match "^F" }
                if ( $Format ) {
                    [void]$sb.Append("<FormatString>" +  $p.${Format} + "</FormatString>");
                }
                $Expression = $p.Keys |?{$_ -match "^E" }
                if ( $Expression )
                {
                    if ( $p.$Expression -is "string" )
                    {
                        [void]$sb.Append("<PropertyName>" + $p.$Expression + "</PropertyName>")
                    }
                    elseif ( $p.$Expression -is "scriptblock" )
                    {
                        [void]$sb.Append("<ScriptBlock>" + $p.$Expression + "</ScriptBlock>")
                    }
                }
                else
                {
                    [void]$sb.Append("<PropertyName>" + $p.Label + "</PropertyName>")
                }
            }
            else {
                throw "Unknown element"
            }
            [void]$sb.AppendLine("</TableColumnItem>")
        }
        [void]$sb.AppendLine("       </TableColumnItems>")
        [void]$sb.AppendLine("      </TableRowEntry>")
        [void]$sb.AppendLine("     </TableRowEntries>")
        [void]$sb.AppendLine("    </TableControl>")
        [void]$sb.AppendLine("   </View>")
        $sb.ToString()
        if ( $StandAlone )
        {
            "   </ViewDefinitions>"
            "</Configuration>"
        }
    }
}


#
# attempt to create a custom format declaration based
# on a template. It needs a lot of work.
# it currently only handles one field per line
#
function New-CustomFormat
{
    param ( $file, [switch]$help )
if ( $args -or $help )
{
@'
Create a Custom Format Entry based on a template.
The first 2 lines must be VIEWNAME and TYPENAME
after that, the template starts. Properties are
enclosed in "[...]" and script properties are enclosed 
in  "{...}"

Example:

VIEWNAME=D0001_1
TYPENAME=SPInventory
Inventory of Windows XP Service Packs
Taken [date]
Computers Running Windows XP : [count]

Service Pack 1
--------------
    {[string]::Join("`n",$_.SP1)}
Total number: {$_.SP1.Count}


'@

    return
}
$lines = [collections.arraylist]::new()
$lines.InsertRange(0,(get-content $file))
$Conf = $false
$Form = $false
if ( $lines[0] -notmatch "VIEWNAME=" ) { write-error "bad template"; exit }
$Junk,$VIEWNAME = $lines[0].split("=")
if ( $lines[1] -notmatch "TYPENAME=" ) { write-error "bad template"; exit }
$Junk,$TYPENAME = $lines[1].split("=")
$lines.RemoveRange(0,2)

@"
<Configuration>
 <ViewDefinitions>
  <View>
   <Name>${VIEWNAME}</Name>
   <ViewSelectedBy>
    <TypeName>${TYPENAME}</TypeName>
   </ViewSelectedBy>
   <CustomControl>
    <CustomEntries>
     <CustomEntry>
      <CustomItem>
"@

function propFrame 
{
param ( $propertyName, $indent = 4)
$frame = @"
       <Frame>
        <LeftIndent>${indent}</LeftIndent>
        <CustomItem>
         <ExpressionBinding>
          <PropertyName>${PropertyName}</PropertyName>
         </ExpressionBinding>
         <NewLine/>
        </CustomItem>
       </Frame>
"@
$frame
}
function exprFrame
{
param ( $script, $indent = 0 )
$frame = @"
       <Frame>
        <LeftIndent>0</LeftIndent>
         <CustomItem>
          <ExpressionBinding>
           <ScriptBlock>${script}</ScriptBlock>
          </ExpressionBinding>
          <NewLine/>
        </CustomItem>
       </Frame>
"@
$frame
}


foreach ( $line in $lines )
{
    if ( $line -match "(.*){(.*)\}(.*)" )
    {
        $text = $matches[1]
        "       <Text>${text}</Text>"
        exprFrame $matches[2]
    }
    elseif ( $line -match "(?<indent>\s*)(?<tag>\w+).*\[(?<property>.[^]]*)]" ) # "(.*)\[(.*)\](.*)" )
    {
        #$text = $matches[1]
        #"       <Text>${text}: </Text>"
        #propFrame $matches[2]
        $text = $matches.tag
        "       <Text>${text}: </Text>"
        propFrame $matches.property $matches.indent.length
    }
    elseif ( $line -notmatch "\[|{" )
    {
        if ( $line )
        {
            "       <Text>${line}</Text>"
        }
        "       <NewLine/>"
    }
    else {
        write-warning "$line not matched"
    }
}

@"
      </CustomItem>
     </CustomEntry>
    </CustomEntries>
   </CustomControl>
  </View>
 </ViewDefinitions>
</Configuration>
"@
}

function Format-String
{
    [CmdletBinding()]
    param ( [string]$string, [int]$width = 76 , [switch]$indent, [int]$padw = 0, [int]$tabWidth = 4)
    END
    {
        $string = $string.Replace("`n", " ").Replace("  ", " ")
        $columns = $width
        $text = $string.split( "[ `t]" )

        $pad = " " * $padw
        $lines = @()
        $l = 0
        $initialTab = ""
        if ( $indent )
        {
            $initialTab = " " * $tabWidth
        }

        $line = $initialTab + $pad
        #"01234567890123456789012345678901234567890123456789"
        foreach ( $word in $text )
        {
            if ( $word.length -gt $columns)
            {
                $wordFragment = $word
                while($wordFragment.Length -gt $columns)
                {
                    $sub = $columns - ($line.length + 1)
                    $line += $wordFragment.Substring(0,$sub)
                    $lines += $line.TrimEnd()
                    $line = $pad
                    $wordFragment = $wordFragment.SubString($sub)
                }
                $line = $wordFragment + " "
            }
            elseif ( $word.length + 1 + $line.length -gt $columns)
            {
                $lines += $line.TrimEnd()
                $line = $pad + $word + " "
            }
            else
            {
                $line += $word + " "
            }
            <#
            if (($line.length + $word.length + 1) -gt $columns )
            {

            }
                if ( ($line.length + $word.length + 1 ) -gt $columns )
                {
                        #"big " + $word
                        $lines += ($pad + $line)
                        $lines += ($pad + $word)
                        $line = ""
                        $l = 0
                }
#                elseif(($pad.length + $l + $word.length + 1) -lt $columns)
#                {
#                        #"ok " + $word
#                        $line += $word + " "
#                        $l += $word.length + 1
#                }
                else
                {
                        #"cr " + $word
                        $lines += ($pad + $line)
                        $line = $word + " "
                        $l = $line.length
                }
                #>
        }
        $lines += $line.TrimEnd()
        #$lines | %{ "${pad}${_}" }
        # if ( ! $indent )
        #{
        #    $lines[0] = $lines[0].Trim()
        # }
        $lines
    }
}

function Get-Lorem
{
    [CmdletBinding()]
    param ([int]$count = 14 )
    END
    {
    $lorem = "Lorem","ipsum","dolor","sit","amet,","consectetaur","adipisicing","elit,",
        "sed","do","eiusmod","tempor","incididunt","ut","labore","et","dolore","magna",
        "aliqua.","Ut","enim","ad","minim","veniam,","quis","nostrud","exercitation",
        "ullamco","laboris","nisi","ut","aliquip","ex","ea","commodo","consequat.","Duis",
        "aute","irure","dolor","in","reprehenderit","in","voluptate","velit","esse","cillum",
        "dolore","eu","fugiat","nulla","pariatur.","Excepteur","sint","occaecat","cupidatat",
        "non","proident,","sunt","in","culpa","qui","officia","deserunt","mollit","anim","id",
        "est","laborum.","Sed","ut","perspiciatis","unde","omnis","iste","natus","error",
        "sit","voluptatem","accusantium","doloremque","laudantium,","totam","rem","aperiam,",
        "eaque","ipsa","quae","ab","illo","inventore","veritatis","et","quasi","architecto",
        "beatae","vitae","dicta","sunt","explicabo.","Nemo","enim","ipsam","voluptatem","quia",
        "voluptas","sit","aspernatur","aut","odit","aut","fugit,","sed","quia","consequuntur","magni",
        "dolores","eos","qui","ratione","voluptatem","sequi","nesciunt.","Neque","porro","quisquam",
        "est,","qui","dolorem","ipsum","quia","dolor","sit","amet,","consectetur,","adipisci",
        "velit,","sed","quia","non","numquam","eius","modi","tempora","incidunt","ut","labore","et",
        "dolore","magnam","aliquam","quaerat","voluptatem.","Ut","enim","ad","minima","veniam,",
        "quis","nostrum","exercitationem","ullam","corporis","suscipit","laboriosam,","nisi","ut","aliquid",
        "ex","ea","commodi","consequatur?","Quis","autem","vel","eum","iure","reprehenderit","qui",
        "in","ea","voluptate","velit","esse","quam","nihil","molestiae","consequatur,","vel",
        "illum","qui","dolorem","eum","fugiat","quo","voluptas","nulla","pariatur?",
        "At","vero","eos","et","accusamus","et","iusto","odio","dignissimos","ducimus","qui",
        "blanditiis","praesentium","voluptatum","deleniti","atque","corrupti","quos","dolores","et",
        "quas","molestias","excepturi","sint","occaecati","cupiditate","non","provident,","similique",
        "sunt","in","culpa","qui","officia","deserunt","mollitia","animi,","id","est","laborum",
        "et","dolorum","fuga.","Et","harum","quidem","rerum","facilis","est","et","expedita",
        "distinctio.","Nam","libero","tempore,","cum","soluta","nobis","est","eligendi","optio",
        "cumque","nihil","impedit","quo","minus","id","quod","maxime","placeat","facere","possimus,",
        "omnis","voluptas","assumenda","est,","omnis","dolor","repellendus.","Temporibus","autem",
        "quibusdam","et","aut","officiis","debitis","aut","rerum","necessitatibus","saepe","eveniet",
        "ut","et","voluptates","repudiandae","sint","et","molestiae","non","recusandae.","Itaque","earum",
        "rerum","hic","tenetur","a","sapiente","delectus,","ut","aut","reiciendis","voluptatibus","maiores",
        "alias","consequatur","aut","perferendis","doloribus","asperiores","repellat."

    $r = get-random -input $lorem -count $count
    $s = $r -join " "
    ([char]::ToUpper($s[0]) + $s.substring(1) + ".")
    }

}
