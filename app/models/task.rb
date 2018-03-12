# class Task
#   API_TASKS_ENDPOINT = "http://localhost:3000/api/v1/tasks"

#   PROPERTIES = [:id, :title, :completed]

#   PROPERTIES.each do |prop|
#     attr_accessor prop
#   end

#   def initialize(hash = {})
#     hash.each do |key, value|
#       if PROPERTIES.member? key.to_sym
#         self.send((key.to_s + "=").to_s, value)
#       end
#     end
#   end

#   def self.all(&block)
#     BW::HTTP.get("#{API_TASKS_ENDPOINT}.json", { headers: Task.headers }) do |response|
#       if response.status_description.nil?
#         App.alert(response.error_message)
#       else
#         if response.ok?
#           json = BW::JSON.parse(response.body.to_str)
#           tasksData = json[:data][:tasks] || []
#           tasks = tasksData.map { |task| Task.new(task) }
#           block.call(tasks)
#         elsif response.status_code.to_s =~ /40\d/
#           App.alert("Not authorized")
#         else
#           App.alert("Something went wrong")
#         end
#       end
#     end
#   end

#   def self.create(params = {}, &block)
#     data = BW::JSON.generate(params)

#     BW::HTTP.post("#{API_TASKS_ENDPOINT}.json", { headers: Task.headers, payload: data } ) do |response|
#       if response.status_description.nil?
#         App.alert(response.error_message)
#       else
#         if response.ok?
#           json = BW::JSON.parse(response.body.to_str)
#           block.call(json)
#         elsif response.status_code.to_s =~ /40\d/
#           App.alert("Task creation failed")
#         else
#           App.alert(response.to_str)
#         end
#       end
#     end
#   end

#   def toggle_completed(&block)
#     url = "#{API_TASKS_ENDPOINT}/#{self.id}/#{self.completed ? 'open' : 'complete'}.json"
#     BW::HTTP.put(url, { headers: Task.headers }) do |response|
#       if response.status_description.nil?
#         App.alert(response.error_message)
#       else
#         if response.ok?
#           json = BW::JSON.parse(response.body.to_str)
#           taskData = json[:data][:task]
#           task = Task.new(taskData)
#           block.call(task)
#         elsif response.status_code.to_s =~ /40\d/
#           App.alert("Not authorized")
#         else
#           App.alert("Something went wrong")
#         end
#       end
#     end
#   end

#   def self.headers
#     {
#       'Content-Type' => 'application/json',
#       'Authorization' => "Token token=\"#{App::Persistence['authToken']}\""
#     }
#   end
# end
