require 'csv'

class Loader
  def load_csv(filename)
    file_data = CSV.read(filename, headers: true, header_converters: :symbol)
    attendee_data = file_data.collect do |row|
      attendee = {
          :id             =>  row[0].to_s,
          :last_name      =>  row[:last_name].to_s,
          :first_name     =>  row[:first_name].to_s,
          :email_address  =>  row[:email_address].to_s,
          :zipcode        =>  clean_zipcode(row[:zipcode]),
          :city           =>  row[:city].to_s,
          :state          =>  row[:state].to_s,
          :street         =>  row[:street].to_s,
          :homephone      =>  clean_phonenum(row[:homephone]).to_s,
          :regdate        =>  row[:regdate].to_s,
          }
    end

    attendee_data
  end

  def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5,"0")[0..4]
  end

  def clean_phonenum(phonenum)
    phone = phonenum.gsub(/\D/, "")
    case 
      when phone.length == 11 && phone[0] == "1" then phone[1..-1]
      when phone.length == 10 then phone
      else "0000000000"
    end
  end
# end of File class
end
