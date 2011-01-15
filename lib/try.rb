class Object
  def try(method, *args, &block)
    self.send(method, *args, &block)
  end
end

class NilClass
  def try(*args)
    nil
  end
end
