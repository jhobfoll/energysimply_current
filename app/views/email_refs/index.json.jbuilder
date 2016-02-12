json.array!(@email_refs) do |email_ref|
  json.extract! email_ref, :id, :email, :ref_date, :refd_by
  json.url email_ref_url(email_ref, format: :json)
end
