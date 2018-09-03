---
layout: post
title: 'Changing the "Return To Shop" link and text in an empty WooCommerce cart'
date: 2016-12-20 23:58
categories: ["wordpress"]
tags: ["wordpress", "woocommerce", "customization", "say-what"]

---

Tonight's learning opportunity provided by the lovely Elise who brings
fun things to research (after some hair pulling and teeth gnashing).

In WooCommerce, if you're cart is empty, it displays a link "Return To
Shop" which if clicked takes you back to the Shop page.

In this case, though, Elise wanted it to go to a different URL, and
didn't want it to say "Return To Shop".

We looked high and low in the plugin, delving through the source and
the html output to try and figure out where this was getting called.

Elise had to leave before we solved it, but later slacked me this
link:

* [Change the Return to shop button URL in the cart page](https://nicola.blog/2015/07/20/change-the-return-to-shop-button-url-in-the-cart-page/)

Meanwhile, I'd grep'd the source tree of the WooCommerce plugin I'd
installed in my sandbaox, and found the following in
`wp-content/plugins/woocommerce/templates/cart/cart-empty.php`, line
36:


{% highlight php linenos %}
<?php
/**
 * Empty cart page
 *
 * This template can be overridden by copying it to yourtheme/woocommerce/cart/cart-empty.php.
 *
 * HOWEVER, on occasion WooCommerce will need to update template files and you
 * (the theme developer) will need to copy the new files to your theme to
 * maintain compatibility. We try to do this as little as possible, but it does
 * happen. When this occurs the version of the template file will be bumped and
 * the readme will list any important changes.
 *
 * @see 	    https://docs.woocommerce.com/document/template-structure/
 * @author  WooThemes
 * @package WooCommerce/Templates
 * @version 2.0.0
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit; // Exit if accessed directly
}

wc_print_notices();

?>

<p class="cart-empty">
	<?php _e( 'Your cart is currently empty.', 'woocommerce' ) ?>
</p>

<?php do_action( 'woocommerce_cart_is_empty' ); ?>

<?php if ( wc_get_page_id( 'shop' ) > 0 ) : ?>
	<p class="return-to-shop">
		<a class="button wc-backward" href="<?php echo esc_url( apply_filters( 'woocommerce_return_to_shop_redirect', wc_get_page_permalink( 'shop' ) ) ); ?>">
			<?php _e( 'Return To Shop', 'woocommerce' ) ?>
		</a>
	</p>
<?php endif; ?>
{% endhighlight %}

This showed the link creating, the variable
`woocommerce_return_to_shop_redirect` filter, and the text being
applied to the anchor tag.

The comments in the file would have led us to copy the above template
and change the text, but that felt wrong, so I went looking for how to
change the localization text that matches 'Return To Shop' in the
woocommerce `.pot` files.

I was directed to the following page:

* [Translating WooCommerce (Localization)](https://docs.woocommerce.com/document/woocommerce-localization/)

down to the last section on the page:

* [Translating Text without a localization file](https://docs.woocommerce.com/document/woocommerce-localization/#section-6)

which in turn led me to the "Say What?" plugin at:

* [Say what? WordPress Plugin](https://wordpress.org/plugins/say-what/)

Now with both of these solutions in hand, Elise is able to change both
the url and the label of the button in the cart.
