local m_string = {}

function m_string.starts_with(p_string, p_sub)
  return string.sub(p_string, 1, string.len(p_sub)) == p_sub
end

return m_string