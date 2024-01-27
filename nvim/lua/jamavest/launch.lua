LAZY_PLUGIN_SPEC = {
  {
    "szw/vim-maximizer",
    event = "VeryLazy",
  },
}

function spec(item)
  table.insert(LAZY_PLUGIN_SPEC, { import = item })
end
