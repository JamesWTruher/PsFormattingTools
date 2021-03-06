Describe "Tests Format-Banner" {
    BeforeAll {
        $strs = "this is","a test"
        $banner = Format-Banner -strings $strs
        $ExpectedOutput = @(
"                                                        ",
"  #####  #    #     #     ####              #     ####  ",
"    #    #    #     #    #                  #    #      ",
"    #    ######     #     ####              #     ####  ",
"    #    #    #     #         #             #         # ",
"    #    #    #     #    #    #             #    #    # ",
"    #    #    #     #     ####              #     ####  ",
"                                                ",
"   ##             #####  ######   ####    ##### ",
"  #  #              #    #       #          #   ",
" #    #             #    #####    ####      #   ",
" ######             #    #            #     #   ",
" #    #             #    #       #    #     #   ",
" #    #             #    ######   ####      #   ",
""
        )
    }
    It "Format-Banner should collect strings correctly" {
        $banner.OriginalStrings[0] | should be $strs[0]
        $banner.OriginalStrings[1] | should be $strs[1]
    }
    It "The ToString method should render the correct output" {
        $StringOutput = $banner.ToString().Split("`n")
        $StringOutput.Count | Should be $expectedOutput.Count
        for($i = 0; $i -lt $StringOutput.Count; $i++) {
            $StringOutput[$i] | Should be $expectedOutput[$i]
        }
    }
    It "The '-asstring' parameter should return the properly formatted banner" {
        $strs = "this is","a test"
        $stringoutput = (Format-Banner -strings $strs -asString).Split("`n")
        $StringOutput.Count | Should be $expectedOutput.Count
        for($i = 0; $i -lt $StringOutput.Count; $i++) {
            $StringOutput[$i] | Should be $expectedOutput[$i]
        }
        
    }
}

Describe "Format-String" {
    BeforeAll {
        $Text = "This is a test of the emergency broadcasting system"
        $longText = "abcd" * 40
        $expectedStrings = "This is a test of the","emergency broadcasting system"
        $expectedWithIndent = "    This is a test of the","emergency broadcasting system"
        $expectedWithPad = "    This is a test of the","    emergency broadcasting","    system"
        $expectedWithPadAndIndent = "        This is a test of the","    emergency broadcasting","    system"
    }
    It "Breaks text correctly" {
        $observedOutput = Format-String -width 30 $Text
        $observedOutput.Count | should be 2
        $observedOutput[0] | should be $expectedStrings[0]
        $observedOutput[1] | should be $expectedStrings[1]
    }
    It "Indents text correctly" {
        $observedOutput = Format-String -width 30 $Text -indent
        $observedOutput.Count | should be 2
        $observedOutput[0] | should be $expectedWithIndent[0]
        $observedOutput[1] | should be $expectedWithIndent[1]
    }
    It "Pads text correctly" {
        $observedOutput = Format-String -width 30 $Text -padw 4
        $observedOutput.Count | should be 3
        $observedOutput[0] | should be $expectedWithPad[0]
        $observedOutput[1] | should be $expectedWithPad[1]
        $observedOutput[2] | should be $expectedWithPad[2]
    }
    It "Pads and indents text correctly" {
        $observedOutput = Format-String -width 30 $Text -padw 4 -indent
        $observedOutput.Count | should be 3
        $observedOutput[0] | should be $expectedWithPadAndIndent[0]
        $observedOutput[1] | should be $expectedWithPadAndIndent[1]
        $observedOutput[2] | should be $expectedWithPadAndIndent[2]
    }

}

Describe "Get-Lorem" {
    It "Returns the proper count of words" {
        (Get-Lorem -count 44).split(" ").Count | Should be 44
    }
    It "The last character is a period" {
        (get-lorem -count 20)[-1] | Should be "."
    }
    It "The first character should be capitalized" {
        (get-lorem -count 10)[0] | Should MatchExactly "[A-Z]"
    }
}

Describe "New-TableFormat" {
    BeforeAll {
        $output = get-date | New-TableFormat day,dayofweek,@{Label="thing";Expr={"static"}}
    }
    It "Should emit valid XML" {
        { [xml]$output } | Should not throw
    }
    It "Should have the proper headers" {
        $x = [xml]$output
        $x.View.TableControl.TableHeaders.TableColumnHeader.Label[0] | should be "day"
        $x.View.TableControl.TableHeaders.TableColumnHeader.Label[1] | should be "dayofweek"
        $x.View.TableControl.TableHeaders.TableColumnHeader.Label[2] | should be "thing"
    }
    It "Should have the proper rows" {
        $x = [xml]$output
        $x.View.TableControl.TableRowEntries.TableRowEntry.TableColumnItems.TableColumnItem[0].PropertyName | should be "day"
        $x.View.TableControl.TableRowEntries.TableRowEntry.TableColumnItems.TableColumnItem[1].PropertyName | should be "dayofweek"
        $x.View.TableControl.TableRowEntries.TableRowEntry.TableColumnItems.TableColumnItem[2].ScriptBlock | should be '"static"'
    }

}