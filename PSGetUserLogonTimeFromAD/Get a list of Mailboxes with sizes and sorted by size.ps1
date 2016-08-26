#
# Get_a_list_of_Mailboxes_with_sizes_and_sorted_by_size.ps1
#

Get-mailbox | get-mailboxstatistics | sort-object totalitemsize –descending | ft displayname,totalitemsize