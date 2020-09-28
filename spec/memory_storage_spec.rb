require_relative '../app/memory_storage'
require_relative '../app/attribute_retriever'

RSpec.describe MemoryStorage do
    describe "Memory storage" do
        before(:each) do 
            @mem_storage = MemoryStorage.new 
            @attribute_retriever = AttributeRetriever.new(0,60,3)
        end
        it "Calls the method set correctly" do
            response = @mem_storage.set("Jhon",@attribute_retriever,"Doe")
            key = @mem_storage.key_list[0]
            expect(key.key_name).to eq("Jhon")
            expect(key.flag).to eq(0)
            expect(key.bits).to eq(3)
            expect(key.value).to eq("Doe")
            expect(key.modification_value).to eq(1)
            expect(response.message).to eq("STORED")
            expect(response.success).to be true
        end

        it "RCalls the method add correctly" do
            response = @mem_storage.add("Jhon",@attribute_retriever,"Doe")
            key = @mem_storage.key_list[0]
            expect(key.key_name).to eq("Jhon")
            expect(key.flag).to eq(0)
            expect(key.bits).to eq(3)
            expect(key.value).to eq("Doe")
            expect(key.modification_value).to eq(1)
            expect(response.message).to eq("STORED")
        end

        it "Calls the method add when entered key already exist" do
            @mem_storage.set("Jhon",@attribute_retriever,"Doe")
            response = @mem_storage.add("Jhon",@attribute_retriever,"Doe")
            expect(response.message).to eq("KEY ALREADY EXIST")
            expect(response.success).to be false
        end

        it "Calls the method replace correctly" do
            @mem_storage.set("Jhon",@attribute_retriever,"Doe")
            attribute_retriever_replace = AttributeRetriever.new(1,60,6)
            response = @mem_storage.replace("Jhon",attribute_retriever_replace,"Garcia")
            key = @mem_storage.key_list[0]
            expect(key.key_name).to eq("Jhon")
            expect(key.flag).to eq(1)
            expect(key.bits).to eq(6)
            expect(key.value).to eq("Garcia")
            expect(key.modification_value).to eq(2)
            expect(response.message).to eq("STORED")
            expect(response.success).to be true
        end

        it "Calls the method replace when entered key does not exist" do
            response = @mem_storage.replace("Jhon",@attribute_retriever,"Doe")
            expect(response.message).to eq("KEY DOES NOT EXIST")
            expect(response.success).to be false
        end

        it "Calls the method append correctly" do
            @mem_storage.set("Jhon",@attribute_retriever,"Doe")
            response = @mem_storage.append("Jhon",7," Garcia")
            key = @mem_storage.key_list[0]
            expect(key.key_name).to eq("Jhon")
            expect(key.flag).to eq(0)
            expect(key.bits).to eq(10)
            expect(key.value).to eq("Doe Garcia")
            expect(key.modification_value).to eq(2)
            expect(response.message).to eq("STORED")
            expect(response.success).to be true
        end

        it "Calls the method append when entered key does not exist" do
            response = @mem_storage.append("Jhon",3,"Doe")
            expect(response.message).to eq("KEY DOES NOT EXIST")
            expect(response.success).to be false
        end

        it "Calls the method prepend correctly" do
            @mem_storage.set("Jhon",@attribute_retriever,"Doe")
            response = @mem_storage.prepend("Jhon",7,"Garcia ")
            key = @mem_storage.key_list[0]
            expect(key.key_name).to eq("Jhon")
            expect(key.flag).to eq(0)
            expect(key.bits).to eq(10)
            expect(key.value).to eq("Garcia Doe")
            expect(key.modification_value).to eq(2)
            expect(response.message).to eq("STORED")
            expect(response.success).to be true
        end

        it "Calls the method prepend when entered key does not exist" do
            response = @mem_storage.prepend("Jhon",3,"Doe")
            expect(response.message).to eq("KEY DOES NOT EXIST")
            expect(response.success).to be false
        end

        it "Calls the method cas correctly when modification_value entered matches the modification_value of the entered key" do
            @mem_storage.set("Jhon",@attribute_retriever,"Doe")
            attribute_retriever_cas= AttributeRetriever.new(0,80,6)
            response = @mem_storage.cas("Jhon",attribute_retriever_cas,"Garcia",1)
            key = @mem_storage.key_list[0]
            expect(key.key_name).to eq("Jhon")
            expect(key.flag).to eq(0)
            expect(key.bits).to eq(6)
            expect(key.value).to eq("Garcia")
            expect(key.modification_value).to eq(2)
            expect(response.message).to eq("STORED")
            expect(response.success).to be true
        end

        it "Calls the method cas correctly when modification_value entered does not match the modification_value of the entered key" do
            @mem_storage.set("Jhon",@attribute_retriever,"Doe")
            attribute_retriever_cas= AttributeRetriever.new(0,80,6)
            response = @mem_storage.cas("Jhon",attribute_retriever_cas,"Garcia",0)
            expect(response.message).to eq("EXIST")
            expect(response.success).to be true
        end

        it "Calls the method cas when entered key does not exist" do
            attribute_retriever_cas= AttributeRetriever.new(0,80,6)
            response = @mem_storage.cas("Jhon",attribute_retriever_cas,"Garcia",1)
            expect(response.message).to eq("KEY DOES NOT EXIST")
            expect(response.success).to be false
        end

        it "Calls the method get correctly" do
            @mem_storage.set("Jhon",@attribute_retriever,"Doe")
            response = @mem_storage.get("Jhon")
            expect(response.message).to eq("VALUE Jhon 0 3 \nDoe \nEND")
            expect(response.success).to be true
        end

        it "Calls the method get when entered key does not exist" do
            @mem_storage.set("Jhon",@attribute_retriever,"Doe")
            response = @mem_storage.get("Jane")
            expect(response.message).to eq("KEY DOES NOT EXIST")
            expect(response.success).to be false
        end

        it "Calls the method gets correctly" do
            @mem_storage.set("Jhon",@attribute_retriever,"Doe")
            response = @mem_storage.gets("Jhon")
            expect(response.message).to eq("VALUE Jhon 0 3 1\nDoe \nEND")
            expect(response.success).to be true
        end

        it "Calls the method gets when entered key does not exist" do
            @mem_storage.set("Jhon",@attribute_retriever,"Doe")
            response = @mem_storage.gets("Jane")
            expect(response.message).to eq("KEY DOES NOT EXIST")
            expect(response.success).to be false
        end

        it "Calls the method delete_key correctly" do
            @mem_storage.set("Jhon",@attribute_retriever,"Doe")
            response = @mem_storage.delete_key("Jhon")
            expect(@mem_storage.key_list).to eq([])
        end

        it "Calls the method key_exist when entered key exist" do
            @mem_storage.set("Jhon",@attribute_retriever,"Doe")
            response = @mem_storage.key_exist("Jhon")
            expect(response).to be true
        end

        it "Calls the method key_exist when entered key does not exist" do
            @mem_storage.set("Jhon",@attribute_retriever,"Doe")
            response = @mem_storage.key_exist("Jane")
            expect(response).to be false
        end

        it "Calls the method retieve key correctly" do
            @mem_storage.set("Jhon",@attribute_retriever,"Doe")
            key = @mem_storage.retrieve_key("Jhon")
            expect(key).to eq(@mem_storage.key_list[0])
        end

        it "Calls the method delete_all_expired_keys correctly" do
            attribute_retriever_set= AttributeRetriever.new(0,0,3)
            @mem_storage.set("Jhon",attribute_retriever_set,"Doe")
            @mem_storage.delete_all_expired_keys
            expect(@mem_storage.key_list).to eq([])
        end
    end
end
