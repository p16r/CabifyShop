#	CabifyShop

##	About

This app follows MVVM architecture and is made with zero external dependencies.

##	Navigation

This app uses the new `NavigationStack` view that's new in iOS 16 for top level navigation, and the `LazyVGrid` view
introduced in uOS 14 to show the fetched products in a grid. The product detail page is presented modally while the
checkout view is pushed on top of the nagivation stack.

##	Accessibility

This app uses Dynamic Type to adapt the text size according to the Dynamic Type size set by the user on their device.
The product grid will also switch between two-column and single-column layout depending on the Dynamic Type size.

## Unit Testing

The unit testing target includes tests for actions like fetching the calatog, adding and removing products to and from
the cart, clearing the cart completely, as well as tests for verifying the expected discounts. A mock API service has
been implemented to prevent network access when the unit tests run.

## Dropped Considerations

Product grid pull-to-refresh has been implemented to work only when the cart is empty. This is to avoid conflicts in the
product discount state while the cart has products.
