class Screenshot
  # https://microlink.io/docs/api/getting-started/overview
  # https://api.microlink.io/?url=https://www.noesya.coop&screenshot=true&meta=false&device=Macbook%20Pro%2015
  # {
  #   "status": "success",
  #   "data": {
  #     "url": "https://www.noesya.coop/",
  #     "screenshot": {
  #       "size_pretty": "1.25 MB",
  #       "size": 1253017,
  #       "type": "png",
  #       "url": "https://iad.microlink.io/9Yn0uu1Ajg4QX8uKdMqglHSQn0o5nfl9dQiyWfLGUcseMgcnpqjjj_YT0yDDSSnr4YF44cALFaYnEfDafjG09w.png",
  #       "width": 2880,
  #       "height": 1800
  #     }
  #   }
  # }
  def self.capture(url)
    response = HTTParty.get('https://api.microlink.io', {
      query: {
        url: url,
        screenshot: true,
        meta: false,
        device: 'Macbook Pro 15'
      }
    })
    data = JSON.parse(response.body)
    data.dig('data', 'screenshot', 'url')
  end
end