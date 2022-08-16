vim.api.nvim_set_var('dbext_default_type', 'PGSQL')
vim.api.nvim_set_var('dbext_default_user', 'postgres')
vim.api.nvim_set_var('dbext_default_buffer_lines', 20)
vim.api.nvim_set_var('dbext_default_prompt_for_parameters', -1) -- Turn off parameter prompt
vim.api.nvim_set_var('dbext_suppress_version_warning', 1)
vim.api.nvim_set_var('dbext_rows_affected', 1)
vim.api.nvim_set_var('dbext_default_use_sep_result_buffer', 1)	-- Each buffer has its own results window
vim.api.nvim_set_var('dbext_default_display_cmd_line', 0)		-- Do NOT display cmd as well
vim.api.nvim_set_var('dbext_default_history_file', '$HOME/.dbext_sql_history.txt')
--vim.api.nvim_set_var('dbext_default_login_script_dir = '$HOME/Dropbox/Work/Sonatype/config/dbext-scripts'
--
--vim.api.nvim_set_var('dbext_default_profile_usual', 'type=PGSQL:user=postgres')

-- source private profiles
vim.cmd('source ~/dev/db_ext_profiles.lua')
