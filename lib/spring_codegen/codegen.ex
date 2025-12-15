defprotocol SpringCodegen.Codegen do
  def to_string(type)
  def module_name(type)
  def name(type)
end
