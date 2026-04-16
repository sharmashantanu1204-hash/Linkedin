// Subscribe form
function handleSubscribe(e) {
  e.preventDefault();
  document.querySelector('.subscribe-form').hidden = true;
  document.getElementById('subscribe-success').hidden = false;
}

// Copy prompt
function copyPrompt(btn) {
  const block = btn.closest('.prompt-block');
  const text = [...block.querySelectorAll('p')].map(p => p.textContent).join('\n\n');
  navigator.clipboard.writeText(text).then(() => {
    btn.textContent = 'Copied!';
    btn.classList.add('copied');
    setTimeout(() => {
      btn.textContent = 'Copy';
      btn.classList.remove('copied');
    }, 2000);
  });
}

// Highlight active TOC link on scroll
const tocLinks = document.querySelectorAll('.toc-inner a');
const sections = ['shift', 'what-are-mcps', 'the-two-mcps', 'setup', 'prompt'].map(id => document.getElementById(id));

const observer = new IntersectionObserver(entries => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      tocLinks.forEach(l => l.classList.remove('active'));
      const active = document.querySelector(`.toc-inner a[href="#${entry.target.id}"]`);
      if (active) active.classList.add('active');
    }
  });
}, { rootMargin: '-20% 0% -70% 0%' });

sections.forEach(s => s && observer.observe(s));
