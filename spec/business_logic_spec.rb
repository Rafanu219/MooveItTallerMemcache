require_relative '../app/business_logic'
require_relative '../app/attribute_retriever'

RSpec.describe BusinessLogic do
    describe "Business Logic" do
        before(:each) do 
            @business_logic = BusinessLogic.new 
        end

        it "Calls the method set when value is not correct" do
            request = ["Jhon","0","60", "2"]
            response = @business_logic.set(request,"Doe")
            expect(response.message).to eq("ERROR: The value does not match bits requested")
            expect(response.success).to be false
        end

        it "Calls the method add when value is not correct" do
            request = ["Jhon","0","60", "2"]
            response = @business_logic.add(request,"Doe")
            expect(response.message).to eq("ERROR: The value does not match bits requested")
            expect(response.success).to be false
        end

        it "Calls the method replace when value is not correct" do
            request = ["Jhon","0","60", "2"]
            response = @business_logic.replace(request,"Doe")
            expect(response.message).to eq("ERROR: The value does not match bits requested")
            expect(response.success).to be false
        end

        it "Calls the method append when value is not correct" do
            request = ["Jhon","0","60", "2"]
            response = @business_logic.append(request,"Doe")
            expect(response.message).to eq("ERROR: The value does not match bits requested")
            expect(response.success).to be false
        end

        it "Calls the method prepend when value is not correct" do
            request = ["Jhon","0","60", "2"]
            response = @business_logic.prepend(request,"Doe")
            expect(response.message).to eq("ERROR: The value does not match bits requested")
            expect(response.success).to be false
        end

        it "Calls the method cas when value is not correct" do
            request = ["Jhon","0","60", "2","0"]
            response = @business_logic.cas(request,"Doe")
            expect(response.message).to eq("ERROR: The value does not match bits requested")
            expect(response.success).to be false
        end

        it "Calls the method create_attribute_retriever correctly" do
            request = ["Set","Jhon","0", "80","4"]
            attribute_retriever = @business_logic.create_attribute_retriever(request)
            expect(attribute_retriever.flag).to eq(0)
            expect(attribute_retriever.time).to eq(80)
            expect(attribute_retriever.bits).to eq(4)
        end

        it "Calls the method check_range when values are correct" do
            request = ["Set","Jhon","0", "80","4"]
            attribute_retriever = @business_logic.create_attribute_retriever(request)
            response = @business_logic.check_range(attribute_retriever)
            expect(response).to be true
        end

        it "Calls the method check_range when flag is incorrect" do
            request = ["Set","Jhon","-1", "80","4"]
            attribute_retriever = @business_logic.create_attribute_retriever(request)
            response = @business_logic.check_range(attribute_retriever)
            expect(response).to be false
        end

        it "Calls the method check_range when time is incorrect" do
            request = ["Set","Jhon","0", "-80","4"]
            attribute_retriever = @business_logic.create_attribute_retriever(request)
            response = @business_logic.check_range(attribute_retriever)
            expect(response).to be false
        end

        it "Calls the method check_range when bits is incorrect" do
            request = ["Set","Jhon","0", "80","-4"]
            attribute_retriever = @business_logic.create_attribute_retriever(request)
            response = @business_logic.check_range(attribute_retriever)
            expect(response).to be false
        end

        it "Calls the method check_range when flag exceeded maximum" do
            request = ["Set","Jhon","1000000000", "80","4"]
            attribute_retriever = @business_logic.create_attribute_retriever(request)
            response = @business_logic.check_range(attribute_retriever)
            expect(response).to be false
        end

        it "Calls the method check_range when time exceeded maximum" do
            request = ["Set","Jhon","0", "100000000000","4"]
            attribute_retriever = @business_logic.create_attribute_retriever(request)
            response = @business_logic.check_range(attribute_retriever)
            expect(response).to be false
        end

        it "Calls the method check_range when bits exceeded maximum" do
            request = ["Set","Jhon","0", "80","100000000"]
            attribute_retriever = @business_logic.create_attribute_retriever(request)
            response = @business_logic.check_range(attribute_retriever)
            expect(response).to be false
        end

        it "Calls the method validate_storage_command with wrong number of arguments" do
            request = ["set","Jhon","0","60","3","4"]
            response = @business_logic.validate_storage_command(request)
            expect(response.message).to eq("ERROR: Wrong number of arguments")
            expect(response.success).to be false
        end

        it "Calls the method validate_cas_storage_command with wrong number of arguments" do
            request = ["cas","Jhon","0","60","3","4","5"]
            response = @business_logic.validate_cas_storage_command(request)
            expect(response.message).to eq("ERROR: Wrong number of arguments")
            expect(response.success).to be false
        end

        it "Calls the method validate_retrieval_command with wrong number of arguments" do
            request = ["get","Jhon","0"]
            response = @business_logic.validate_retrieval_command(request)
            expect(response.message).to eq("ERROR: Wrong number of arguments")
            expect(response.success).to be false
        end

        it "Calls the method validate_value with correct value" do
            request = ["set","Jhon","0","60","3"]
            response = @business_logic.validate_value(request,"Doe")
            expect(response).to be true
        end

        it "Calls the method validate_value with correct value" do
            request = ["set","Jhon","0","60","4"]
            response = @business_logic.validate_value(request,"Doe")
            expect(response).to be false
        end

        it "Calls the method parse_flag with correct flag" do
            flag = @business_logic.parse_flag("4")
            expect(flag).to eq(4)
        end

        it "Calls the method parse_time with correct flag" do
            time = @business_logic.parse_time("4")
            expect(time).to eq(4)
        end

        it "Calls the method parse_bits with correct bits" do
            bits = @business_logic.parse_bits("4")
            expect(bits).to eq(4)
        end

        it "Calls the method parse_modification_value with correct modification_value" do
            modification_value = @business_logic.parse_modification_value("4")
            expect(modification_value).to eq(4)
        end

        it "Calls the method parse_flag with incorrect flag" do
            response = @business_logic.parse_flag("a")
            expect(response.message).to eq("ERROR: Flag must be an integer")
            expect(response.success).to be false
        end

        it "Calls the method parse_time with incorrect time" do
            response = @business_logic.parse_time("a")
            expect(response.message).to eq("ERROR: Time must be an integer")
            expect(response.success).to be false
        end

        it "Calls the method parse_bits with incorrect bits" do
            response = @business_logic.parse_bits("a")
            expect(response.message).to eq("ERROR: Bits must be an integer")
            expect(response.success).to be false
        end

        it "Calls the method parse_modification_value with incorrect modification_value" do
            response = @business_logic.parse_modification_value("a")
            expect(response.message).to eq("ERROR: Modification value must be an integer")
            expect(response.success).to be false
        end
    end
end