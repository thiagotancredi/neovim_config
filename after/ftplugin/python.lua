-- Só ativa se houver pyproject.toml no diretório do projeto
local project_root = vim.fn.getcwd()
local pyproject = project_root .. "/pyproject.toml"

if vim.fn.filereadable(pyproject) == 1 then
    -- Busca o venv do Poetry
    local venv_path = vim.fn.trim(vim.fn.system("poetry env info --path 2>/dev/null"))

    -- Se encontrou, usa como Python principal
    if venv_path ~= "" then
        vim.g.python3_host_prog = venv_path .. "/bin/python"
    end
end
