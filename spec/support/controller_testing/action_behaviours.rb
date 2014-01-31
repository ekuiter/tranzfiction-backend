module ActionBehaviours
  def assigns(*options, &block)
    raise ArgumentError unless options
    if options.length > 1
      options.uniq.each do |variable|
        assigns(variable, &block)
      end
    else
      variable = options.first.to_sym
      it("assigns @#{variable}") do
        assigned_value = if block then instance_eval(&block) else send(variable) end
        expect(assigns(variable)).to eq assigned_value
      end
    end
    self
  end

  def renders(hash=nil, &block)
    if hash.kind_of? Hash
      if hash[:template]
        template = hash[:template].to_sym
        block ||= proc { template }
        it "renders template #{template}" do
          expect(response).to render_template instance_eval(&block)
        end
      elsif hash[:json]
        variable = hash[:json].to_sym
        block ||= proc { send(variable) }
        it "renders @#{variable} as JSON" do
          expect(response.body).to be_json instance_eval(&block)
        end
      end
    elsif hash == :json
      it "renders json" do
        expect(response.body).to be_json(if block then instance_eval(&block) end)
      end
    elsif block
      it("renders") { expect(response.body).to eq instance_eval(&block) }
    else
      it("renders #{hash}") { expect(response.body).to eq hash }
    end
    self
  end

  def destroys(&block)
    raise ArgumentError unless block
    it "destroys" do
      hash = instance_eval &block
      collection = hash.delete :collection
      expect { get :destroy, hash }.to change { collection.count }.by(-1)
    end
    self
  end
end