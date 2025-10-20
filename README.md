# Jekyll Bitly Next

[![Tests](https://github.com/saiqulhaq/jekyll_bitly_next/actions/workflows/test.yml/badge.svg)](https://github.com/saiqulhaq/jekyll_bitly_next/actions/workflows/test.yml)

A modern, maintained Jekyll plugin that provides Bitly URL shortening filters for your Jekyll sites.

## 🔗 About

This gem is a maintained fork of [jekyll-bitly](https://github.com/tbjers/jekyll-bitly), which is no longer actively maintained. It provides seamless integration with Bitly's API to automatically shorten URLs in your Jekyll pages and posts.

## ✨ Features

- 🚀 Simple Liquid filter for URL shortening
- 🔐 Secure token management via config or environment variables
- 💾 Automatic caching of shortened URLs
- 🎯 Zero configuration required after token setup
- 🧪 Fully tested and maintained

## 📦 Installation

### Using Bundler (Recommended)

Add this line to your `Gemfile`:

```ruby
gem 'jekyll_bitly_next'
```

Then execute:

```bash
bundle install
```

### Manual Installation

```bash
gem install jekyll_bitly_next
```

### Configure Jekyll

Add the plugin to your `_config.yml`:

```yaml
plugins:
  - jekyll_bitly_next
```

**Note:** Older Jekyll versions used `gems:` instead of `plugins:`. If you're using an older version, use:

```yaml
gems:
  - jekyll_bitly_next
```

## 🔑 Configuration

### Step 1: Get Your Bitly API Token

1. Log in to your Bitly account
2. Navigate to [https://app.bitly.com/settings/api/](https://app.bitly.com/settings/api/)
3. Generate a new API token
4. Copy the token for use in the next step

### Step 2: Configure the Token

You can configure your Bitly token using either of these methods:

#### Option 1: Jekyll Config (Recommended for local development)

Add to your `_config.yml`:

```yaml
bitly:
  token: YOUR_BITLY_API_TOKEN_HERE
```

**⚠️ Security Warning:** Never commit your API token to public repositories. Add `_config.yml` to `.gitignore` or use environment variables for production.

#### Option 2: Environment Variable (Recommended for production)

Set the `BITLY_TOKEN` environment variable:

```bash
# Linux/macOS
export BITLY_TOKEN=YOUR_BITLY_API_TOKEN_HERE

# Windows (Command Prompt)
set BITLY_TOKEN=YOUR_BITLY_API_TOKEN_HERE

# Windows (PowerShell)
$env:BITLY_TOKEN="YOUR_BITLY_API_TOKEN_HERE"
```

For permanent setup, add it to your `.bashrc`, `.zshrc`, or system environment variables.

**Priority:** Config file settings take precedence over environment variables.

## 🚀 Usage

### Basic Usage

Use the `bitly` filter in your Jekyll templates, pages, or posts:

```liquid
[Visit the Bitly gem]({{ 'https://github.com/philnash/bitly' | bitly }})
```

### Advanced Examples

**In blog posts:**

```liquid
---
layout: post
title: "My Awesome Post"
canonical_url: https://yourdomain.com/2025/10/awesome-post
---

Share this post: {{ page.canonical_url | bitly }}
```

**In layouts:**

```liquid
<a href="{{ page.url | absolute_url | bitly }}" class="share-link">
  Share on Twitter
</a>
```

**With site variables:**

```liquid
{% assign short_url = site.url | append: page.url | bitly %}
<meta property="og:url" content="{{ short_url }}" />
```

## 🛠️ Development

### Prerequisites

- Ruby 2.7 or higher
- Bundler

### Setup

1. Clone the repository:

```bash
git clone https://github.com/saiqulhaq/jekyll_bitly_next.git
cd jekyll_bitly_next
```

2. Install dependencies:

```bash
bin/setup
# or
bundle install
```

3. Run the tests:

```bash
bundle exec rspec
```

4. Run an interactive console:

```bash
bin/console
```

### Making Changes

1. Create a feature branch: `git checkout -b my-feature`
2. Make your changes
3. Add tests for your changes
4. Run tests: `bundle exec rspec`
5. Commit your changes: `git commit -am 'Add new feature'`
6. Push to the branch: `git push origin my-feature`
7. Create a Pull Request

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Report bugs:** Open an issue on [GitHub](https://github.com/saiqulhaq/jekyll_bitly_next/issues)
2. **Suggest features:** Open an issue with your ideas
3. **Submit pull requests:** Fork, create a feature branch, and submit a PR
4. **Improve documentation:** Help us make the docs better

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project, you agree to abide by its terms.

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes in each version.

## 📄 License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## 🙏 Credits

- Original gem by [Torgny Bjers](https://github.com/tbjers)
- Maintained by [Saiqul Haq](https://github.com/saiqulhaq)
- Built with [Bitly API](https://dev.bitly.com/)