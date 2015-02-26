class Asana 

	def self.create_task(workspace, project, name)
    endpoint = "https://app.asana.com/api/1.0/tasks"

    request_body = {
      "data" => {
        "workspace" => workspace,
        "name" => name,
        "projects" => [project]
      }
    }

    response = AsanaRequest.new(endpoint).post_response(request_body)
    body = JSON.parse(response.body)
    if body['errors'] then
      puts "error: #{body['errors'][0]['message']}"
    else
      return body['data']['id']
    end
  end

  def self.create_attachment(task_id, attachment)
    endpoint = "https://app.asana.com/api/1.0/tasks/#{task_id}/attachments"
    
    response = AsanaRequest.new(endpoint).post_attachment_response(attachment.content_type, attachment.tempfile)
    body = JSON.parse(response.body)
    if body['errors'] then
      puts "error: #{body['errors'][0]['message']}"
    else
      return "Attachment Created"
    end
  end

  def self.create_comment(task_id, text)
    endpoint = "https://app.asana.com/api/1.0/tasks/#{task_id}/stories"
    
    request_body = {
      "data" => {
        "text" => text,
        "type" => "comment"
      }
    }

    response = AsanaRequest.new(endpoint).post_response(request_body)
    body = JSON.parse(response.body)
    if body['errors'] then
      puts "error: #{body['errors'][0]['message']}"
    else
      return "Comment Created"
    end
  end

  def self.get_comments(task_id)
    endpoint = "https://app.asana.com/api/1.0/tasks/#{task_id}/stories"
    
    request_body = ""

    response = AsanaRequest.new(endpoint).get_response(request_body)
    body = JSON.parse(response.body)
    if body['errors'] then
      puts "error: #{body['errors'][0]['message']}"
    else
      return body
    end
  end
end