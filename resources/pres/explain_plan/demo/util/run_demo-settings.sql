-- Host command for writing the content of a file to stdout
-- Use "cat" if running on Unix, "type" if running on Windows
--
define def_host_cmd_cat = "type"    -- Windows
--define def_host_cmd_cat = "cat"     -- Unix

-- Host command for deleting a file on disk
-- Use "rm -f" if running on Unix, "del" if running on Windows
--
define def_host_cmd_rm = "del"      -- Windows
--define def_host_cmd_rm = "rm -f"    -- Unix