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
# Base HTML (Discord Theme)
# -------------------------
base_html = """
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>All Tasks - GoonSquad</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
      body {
        background-color: #2f3136;
        color: #dcddde;
      }
      .navbar {
        background-color: #202225 !important;
      }
      .card {
        background-color: #36393f;
        border: none;
        color: #dcddde;
        margin-bottom: 2rem;
      }
      .form-control {
        background-color: #40444b;
        border: 1px solid #202225;
        color: #fff;
      }
      .form-control:focus {
        background-color: #40444b;
        color: #fff;
        border-color: #5865f2;
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
    </style>
  </head>
  <body>
    <nav class="navbar navbar-expand-lg mb-4">
      <div class="container">
        <a class="navbar-brand text-light" href="/">GoonSquad: Padlan and Paraon</a>
      </div>
    </nav>
    <div class="container">
      <div class="card shadow p-4">
        <h2 class="mb-3">Task 1: Average Calculator</h2>
        <form method="post">
          <div class="mb-3">
            <label class="form-label">Number 1</label>
            <input type="text" class="form-control" name="num1">
          </div>
          <div class="mb-3">
            <label class="form-label">Number 2</label>
            <input type="text" class="form-control" name="num2">
          </div>
          <button type="submit" name="action" value="average" class="btn btn-primary">Calculate</button>
        </form>
        {% if average_result is not none %}
          <div class="alert alert-info mt-3"><b>Result:</b> {{ average_result }}</div>
        {% endif %}
      </div>

      <div class="card shadow p-4">
        <h2 class="mb-3">Task 2: Unique Words</h2>
        <form method="post">
          <div class="mb-3">
            <label class="form-label">Sentence</label>
            <input type="text" class="form-control" name="sentence">
          </div>
          <button type="submit" name="action" value="unique" class="btn btn-primary">Find Unique Words</button>
        </form>
        {% if unique_result %}
          <div class="alert alert-success mt-3">Found <b>{{ unique_count }}</b> unique words.</div>
          <ul class="list-group mt-2">
            {% for word in unique_result %}
              <li class="list-group-item">{{ word }}</li>
            {% endfor %}
          </ul>
        {% endif %}
      </div>

      <div class="card shadow p-4">
        <h2 class="mb-3">Task 3: Word Frequency</h2>
        <form method="post">
          <div class="mb-3">
            <label class="form-label">Sentence</label>
            <input type="text" class="form-control" name="sentence">
          </div>
          <button type="submit" name="action" value="frequency" class="btn btn-primary">Count Frequencies</button>
        </form>
        {% if frequency_result %}
          <ul class="list-group mt-2">
            {% for word, freq in frequency_result.items() %}
              <li class="list-group-item d-flex justify-content-between align-items-center">
                {{ word }}
                <span class="badge bg-primary rounded-pill">{{ freq }}</span>
              </li>
            {% endfor %}
          </ul>
        {% endif %}
      </div>
    </div>
  </body>
</html>
"""

# -------------------------
# Single Page Route
# -------------------------
@app.route('/', methods=['GET', 'POST'])
def home():
    average_result = None
    unique_result, unique_count = None, None
    frequency_result = None

    if request.method == 'POST':
        action = request.form.get('action')

        if action == 'average':
            try:
                num1 = float(request.form['num1'])
                num2 = float(request.form['num2'])
                average_result = average_func(num1, num2)
            except ValueError:
                average_result = "Invalid input!"

        elif action == 'unique':
            sentence = request.form['sentence']
            unique_result, unique_count = unique_words(sentence)

        elif action == 'frequency':
            sentence = request.form['sentence']
            frequency_result = word_frequency(sentence)

    return render_template_string(
        base_html,
        average_result=average_result,
        unique_result=unique_result,
        unique_count=unique_count,
        frequency_result=frequency_result
    )


if __name__ == '__main__':
    app.run(debug=True)
