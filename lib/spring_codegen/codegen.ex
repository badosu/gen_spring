defprotocol SpringCodegen.Codegen do
  def to_string(type, metamodel)
  def module_name(type)
  def name(type)
  def parse(command, words, sentences)
end
