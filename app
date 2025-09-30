from flask import Flask, request, render_template_string

app = Flask(__name__)

# -------------------------
# Task 1: Average Function
# -------------------------
def average_func(num1, num2):
    return (num1 + num2) / 2

# -------------------------
# Task 2: Unique Words
# -------------------------
def unique_words(sentence):
    words = sentence.split()
    unique = set(words)
    return unique, len(unique)

# -------------------------
# Task 3: Word Frequency
# -------------------------
def word_frequency(sentence):
    sentence = sentence.lower()
    words = sentence.split()
    freq = {}
    for word in words:
        freq[word] = freq.get(word, 0) + 1
    return freq


# -------------------------
# Base HTML with Discord-like Theme
# -------------------------
base_html = """
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ title }}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
      body {
        background-color: #2f3136;  /* Discord dark gray */
        color: #dcddde;            /* Light gray text */
      }
      .navbar {
        background-color: #202225 !important; /* Darker navbar */
      }
      .card {
        background-color: #36393f;
        border: none;
        color: #dcddde;
      }
      .form-control {
        background-color: #40444b;
        border: 1px solid #202225;
        color: #fff;
      }
      .form-control:focus {
        background-color: #40444b;
        color: #fff;
        border-color: #5865f2; /* Discord blurple */
        box-shadow: 0 0 0 0.2rem rgba(88, 101, 242, 0.25);
      }
      .btn-primary {
        background-color: #5865f2;
        border-color: #5865f2;
      }
      .btn-primary:hover {
        background-color: #4752c4;
        border-color: #4752c4;
      }
      .list-group-item {
        background-color: #2f3136;
        border: 1px solid #202225;
        color: #dcddde;
      }
      .alert-info {
        background-color: #5865f2;
        border: none;
        color: white;
      }
      .alert-success {
        background-color: #43b581;
        border: none;
        color: white;
      }
      .badge.bg-primary {
        background-color: #5865f2 !important;
      }
      a, a:hover {
        color: #5865f2;
        text-decoration: none;
      }
    </style>
  </head>
  <body>
    <nav class="navbar navbar-expand-lg mb-4">
      <div class="container">
        <a class="navbar-brand text-light" href="/">GoonSquad: Padlan and Paraon</a>
        <div>
          <ul class="navbar-nav">
            <li class="nav-item"><a class="nav-link text-light" href="/average">Average</a></li>
            <li class="nav-item"><a class="nav-link text-light" href="/unique">Unique Words</a></li>
            <li class="nav-item"><a class="nav-link text-light" href="/frequency">Word Frequency</a></li>
          </ul>
        </div>
      </div>
    </nav>
    <div class="container">
      <div class="card shadow p-4">
        <h2 class="mb-3">{{ title }}</h2>
        {{ content|safe }}
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
"""

# -------------------------
# Flask Routes
# -------------------------

@app.route('/')
def home():
    content = """
      <p class="lead">Welcome to the page for GoonSquad's Hackathon Task 1-3. Choose a tool below:</p>
      <ul class="list-group">
        <li class="list-group-item"><a href="/average">Average Calculator</a></li>
        <li class="list-group-item"><a href="/unique">Unique Words</a></li>
        <li class="list-group-item"><a href="/frequency">Word Frequency</a></li>
      </ul>
    """
    return render_template_string(base_html, title="Home", content=content)


@app.route('/average', methods=['GET', 'POST'])
def average():
    result = None
    if request.method == 'POST':
        try:
            num1 = float(request.form['num1'])
            num2 = float(request.form['num2'])
            result = average_func(num1, num2)
        except ValueError:
            result = "Invalid input!"
    content = """
      <form method="post" class="mb-3">
        <div class="mb-3">
          <label class="form-label">Number 1</label>
          <input type="text" class="form-control" name="num1">
        </div>
        <div class="mb-3">
          <label class="form-label">Number 2</label>
          <input type="text" class="form-control" name="num2">
        </div>
        <button type="submit" class="btn btn-primary">Calculate</button>
      </form>
    """
    if result is not None:
        content += f"<div class='alert alert-info mt-3'><b>Result:</b> {result}</div>"
    return render_template_string(base_html, title="Average Calculator", content=content)


@app.route('/unique', methods=['GET', 'POST'])
def unique():
    result, count = None, None
    if request.method == 'POST':
        sentence = request.form['sentence']
        result, count = unique_words(sentence)
    content = """
      <form method="post" class="mb-3">
        <div class="mb-3">
          <label class="form-label">Sentence</label>
          <input type="text" class="form-control" name="sentence" size="50">
        </div>
        <button type="submit" class="btn btn-primary">Find Unique Words</button>
      </form>
    """
    if result:
        content += f"<div class='alert alert-success mt-3'>Found <b>{count}</b> unique words.</div>"
        content += "<ul class='list-group mt-2'>"
        for word in result:
            content += f"<li class='list-group-item'>{word}</li>"
        content += "</ul>"
    return render_template_string(base_html, title="Unique Words", content=content)


@app.route('/frequency', methods=['GET', 'POST'])
def frequency():
    result = None
    if request.method == 'POST':
        sentence = request.form['sentence']
        result = word_frequency(sentence)
    content = """
      <form method="post" class="mb-3">
        <div class="mb-3">
          <label class="form-label">Sentence</label>
          <input type="text" class="form-control" name="sentence" size="50">
        </div>
        <button type="submit" class="btn btn-primary">Count Frequencies</button>
      </form>
    """
    if result:
        content += "<ul class='list-group mt-2'>"
        for word, freq in result.items():
            content += f"<li class='list-group-item d-flex justify-content-between align-items-center'>{word}<span class='badge bg-primary rounded-pill'>{freq}</span></li>"
        content += "</ul>"
    return render_template_string(base_html, title="Word Frequency", content=content)


if __name__ == '__main__':
    app.run(debug=True)
