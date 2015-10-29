# PsFormatting Tools

This module has a few text processing utilities that I have used over the
past few years


### Format-Banner
Do you long for those bygone days when you could create text banners,
well now you can
```

 PS> format-banner Format Tools -asString
 #######
 #         ####   #####   #    #    ##     #####
 #        #    #  #    #  ##  ##   #  #      #
 #####    #    #  #    #  # ## #  #    #     #
 #        #    #  #####   #    #  ######     #
 #        #    #  #   #   #    #  #    #     #
 #         ####   #    #  #    #  #    #     #

 #######
    #      ####    ####   #        ####
    #     #    #  #    #  #       #
    #     #    #  #    #  #        ####
    #     #    #  #    #  #            #
    #     #    #  #    #  #       #    #
    #      ####    ####   ######   ####

``` 

### Get-Lorem
Do you need some temp text, I got you covered

```
PS> get-lorem -count 32
Laboriosam, veritatis amet, minima consectetur, aut Temporibus assumenda 
ullam atque delectus, exercitationem vitae dolor non vol uptate aliqua. 
ea in vel dolore eius Ut dolor et Duis et qui cupidatat quibusdam quo esse.

```

### Format-String
Would you like to format your string as in a paragraph? Format-String
might do the trick!

```
PS> $s = get-lorem -count 32
PS> format-string -width 40 -padw 4 -indent -string $ss
        Placeat officiis et Lorem et
    qui quia animi, saepe ullamco
    tempore, pariatur. qui sapiente aut
    consectetur, mollitia occaecat
    voluptas pariatur? cupidatat dolore
    voluptate dolore ipsum aperiam,
    sunt quam harum sit et praesentium
    iure ea.

```
### New-TableFormat
Having trouble creating format.ps1xml files? New-TableFormat will help, get 
your output looking like you want, and then replace format-table with
new-tableformat and use the XML in your format.ps1xml file!

```
PS> get-date | format-table date,dayofweek

Date                   DayOfWeek
----                   ---------
10/29/2015 12:00:00 AM  Thursday


PS> get-date | new-tableformat date,dayofweek
   <View>
    <Name>DateTimeTable</Name>
    <ViewSelectedBy>
     <TypeName>System.DateTime</TypeName>

    </ViewSelectedBy>
    <TableControl>
     <TableHeaders>
      <TableColumnHeader><Label>date</Label></TableColumnHeader>
      <TableColumnHeader><Label>dayofweek</Label></TableColumnHeader>
     </TableHeaders>
     <TableRowEntries>
      <TableRowEntry>
       <TableColumnItems>
        <TableColumnItem><PropertyName>date</PropertyName></TableColumnItem>
        <TableColumnItem><PropertyName>dayofweek</PropertyName></TableColumnItem>
       </TableColumnItems>
      </TableRowEntry>
     </TableRowEntries>
    </TableControl>
   </View>
```


