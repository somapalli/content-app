document.addEventListener('DOMContentLoaded', () => {
    const contentGrid = document.getElementById('contentGrid');
    const addContentBtn = document.getElementById('addContentBtn');

    // Function to create a content item
    function createContentItem(text) {
        const div = document.createElement('div');
        div.className = 'content-item';
        div.innerHTML = `<pre>${text}</pre>`;
        return div;
    }

    // Function to load content from text file
    async function loadContentFromFile() {
        try {
            const response = await fetch('/content.txt');
            const text = await response.text();
            
            // Create a content item with the raw text
            contentGrid.appendChild(createContentItem(text));
        } catch (error) {
            console.error('Error loading content:', error);
            // Fallback content if file loading fails
            contentGrid.appendChild(createContentItem('Error Loading Content: Unable to load content from file. Please try again later.'));
        }
    }

    // Load initial content from file
    loadContentFromFile();

    // Add new content when button is clicked
    addContentBtn.addEventListener('click', () => {
        contentGrid.appendChild(createContentItem('New Content Item\nThis is a new content item. Edit this to add your own content.'));
    });
});
