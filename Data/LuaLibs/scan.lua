function scandir(dirname)
        callit = os.tmpname()
        os.execute("ls -a1 "..dirname .. " >"..callit)
        f = io.open(callit,"r")
        rv = f:read("*all")
        f:close()
        os.remove(callit)

        tabby = {}
        local from  = 1
        local delim_from, delim_to = string.find( rv, "\n", from  )
        while delim_from do
                table.insert( tabby, string.sub( rv, from , delim_from-1 ) )
                from  = delim_to + 1
                delim_from, delim_to = string.find( rv, "\n", from  )
                end
        -- table.insert( tabby, string.sub( rv, from  ) )
        -- Comment out eliminates blank line on end!
        return tabby
        end
