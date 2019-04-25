
function! termopen#get_selected() range
    if mode()=="v"
        let [line_start, column_start] = getpos("v")[1:2]
        let [line_end, column_end] = getpos(".")[1:2]
    else
        let [line_start, column_start] = getpos("'<")[1:2]
        let [line_end, column_end] = getpos("'>")[1:2]
    end
    if (line2byte(line_start)+column_start) > (line2byte(line_end)+column_end)
        let [line_start, column_start, line_end, column_end] =
        \   [line_end, column_end, line_start, column_start]
    end
    echo "Byebye"
    return getline(line_start)[column_start-1:column_end-1]
endfunction

function! termopen#get_full_path() range
	let termid   = matchstr(@%, "[0-9].*[0-9]")
	let termpath = system('readlink "/proc/'.termid.'/cwd"')
	let vs_path  = termopen#get_selected()
	let f_path   = termpath[:-2]."/".vs_path
	return f_path
endfunction

function! termopen#open() range
	execute("e ".termopen#get_full_path())
endfunction

function! termopen#open_new_tab() range
	execute("tabnew ".termopen#get_full_path())
endfunction
